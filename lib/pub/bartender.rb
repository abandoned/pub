class Pub
  class Bartender
    def initialize(pub_name)
      @pub_name = pub_name
    end

    # Serves an order.
    def serve(order, &block)
      bar_counter.publish([@pub_name, order].join(':'), block.call)
    end

    # Takes one or more orders.
    #
    #   orders = bartender.take_orders(3)
    #   orders.each do |order|
    #       bartender.serve(order) do
    #       # prepare drink
    #     end
    #   end
    def take_orders(count = 1)
      orders = Array.new

      # Seems I can't use a simple map here.
      count.times do
        order = bar_counter.lpop(@pub_name)
        break if order.nil?
        orders << order
      end

      orders
    end

    private

    def bar_counter
      @bar_counter ||= Pub.bar_counter
    end
  end
end
