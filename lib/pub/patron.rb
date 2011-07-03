module Pub
  # A patron.
  #
  # In other words, a consumer in our processing queue.
  class Patron
    include Helpers

    # Creates a new pub patron.
    #
    # Takes the name of the pub and a value for patience.
    def initialize(pub_name, patience)
      @pub_name, @patience = pub_name, patience
    end

    # The patron's patience.
    #
    # Measured in seconds. This designates how long a patron is willing to wait
    # at the counter.
    attr_accessor :patience

    # Orders one or more beer at the bar counter.
    #
    # If given a block, yields beers as they become available. Otherwise,
    # returns all on a tray.
    #
    # If not all beers are served within specified timeout, it will return only
    # the beers that are ready.
    def order(*beers)
      raise ArgumentError, 'Empty order' if beers.empty?

      orders, tray = [], []

      beers.flatten!

      beers.each do |beer|
        counter.rpush(@pub_name, beer)
        orders << order_for(beer)
      end

      timer = EM.add_timer(@patience) do
        counter.unsubscribe
      end

      counter.subscribe(*orders) do |on|
        on.message do |order, beer|
          counter.unsubscribe(order)
          if block_given?
            yield beer
          else
            tray << beer
          end
        end
      end

      EM.cancel_timer(timer)
      block_given? ? nil : tray
    end
  end
end
