module Pub
  # A bartender.
  #
  # In other words, a producer in our processing queue.
  class Bartender
    include Helpers

    # Creates a new bartender.
    #
    # Takes the name of the pub.
    def initialize(pub_name)
      @pub_name = pub_name
    end

    # Serves a beer to a thirsty patron.
    #
    # Takes a block which should return a glass of beer.
    #
    # See below for example usage.
    def serve(beer, &block)
      counter.lrem(@pub_name, 0, beer)
      counter.publish(order_for(beer), block.call)
    end

    # Takes one or more orders from the queue.
    #
    #   orders = bartender.take_orders(3)
    #   orders.each do |order|
    #       bartender.serve(order) do
    #         "A pint of #{order}"
    #     end
    #   end
    def take_orders(count = 1)
      orders = Array.new

      count.times do
        order = counter.lpop(@pub_name) || break
        orders << order
      end

      orders
    end
  end
end
