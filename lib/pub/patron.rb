module Pub
  # A pub patron.
  class Patron
    include Helpers

    attr_accessor :timeout

    # Creates a new pub patron.
    #
    # Takes the name of the pub and an optional hash of options. The latter
    # respects the following members:
    #
    # * `:timeout`, which specifies a timeout value, in seconds, for a pending
    # order. Defaults to nil.
    def initialize(pub_name, opts = {})
      @pub_name = pub_name
      @timeout  = opts[:timeout]
    end

    # Orders one or more beer at the bar counter.
    #
    # If given a block, yields beers as they become available. Otherwise,
    # returns all on a tray.
    def order(*beers)
      # TODO disentangle procedural code.
      raise ArgumentError, 'Empty order' if beers.empty?

      orders, tray = [], []

      beers.flatten!

      beers.each do |beer|
        # TODO: Order all beers at once when Redis stable bumps past 2.3.
        # cf. http://redis.io/commands/rpush
        counter.rpush(@pub_name, beer)
        orders << order_for(beer)
      end

      if @timeout
        timer = EM.add_timer(@timeout) do
          counter.unsubscribe
          Fiber.new do
            counter = Pub.counter
            orders.each do |order|
              other_pending_orders = counter.publish(order, 'NOOP')
              if other_pending_orders == 0
                # TODO Racy, even if infitesimally!
                beer = order.gsub(/^.*:+/, '')
                counter.lrem(@pub_name, 0, beer)
              end
            end
          end.resume
        end
      end

      counter.subscribe(*orders) do |on|
        on.message do |order, beer|
          unless beer == 'NOOP'
            counter.unsubscribe(order)
            orders.delete(order)
            if block_given?
              yield beer
            else
              tray << beer
            end
          end
        end
      end

      EM.cancel_timer(timer) if timer
      block_given? ? nil : tray
    end
  end
end
