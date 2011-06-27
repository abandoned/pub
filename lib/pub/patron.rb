class Pub
  class Patron
    # Creates a new pub patron.
    #
    # Takes the name of the pub.
    def initialize(pub_name)
      @pub_name = pub_name
      @timeout  = 30
    end

    # Orders one or more drinks at the bar counter.
    #
    # If given a block, yields drinks as they become available. Otherwise,
    # returns all drinks on a tray.
    def order(*drinks)
      raise ArgumentError, 'Empty order' if drinks.empty?

      orders, tray = [], []

      # Order drinks at the counter.
      drinks.each do |drink|
        Pub.counter.rpush(@pub_name, drink)
        orders << [@pub_name, drink].join(':')
      end

      timer = EM.add_timer(@timeout) do
        stool.unsubscribe
      end

      # Sit on a stool and wait.
      stool.subscribe(*orders) do |on|
        on.message do |order, drink|
          stool.unsubscribe(order)
          if block_given?
            yield drink
          else
            tray << drink
          end
        end
      end

      EM.cancel_timer(timer)
      block_given? ? nil : tray
    end

    # Sets how long the patron will wait for an order to be served.
    def waits_no_more_than(seconds)
      @timeout = seconds
    end

    private

    def stool
      @stool ||= Pub.stool
    end
  end
end
