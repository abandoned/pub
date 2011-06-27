class Pub
  class Bartender
    def initialize(pub_name)
      @pub_name = pub_name
    end

    # Serves an order.
    def serve(drink, &block)
      Pub.counter.publish([@pub_name, order].join(':'), block.call)
    end

    # Takes one or more orders.
    #
    #   drinks = bartender.take_orders(3)
    #   drinks.each do |drink|
    #       bartender.serve(drink) do
    #       # prepare drink
    #     end
    #   end
    def take_orders(count = 1)
      drinks = Array.new

      # Seems I can't use a simple map here.
      count.times do
        drink = Pub.counter.lpop(@pub_name)
        break if drink.nil?
        drinks << drink
      end

      drinks
    end
  end
end
