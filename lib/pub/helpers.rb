class Pub
  # Methods used by both patron and bartender.
  module Helpers
    # A specific order.
    #
    # This is a pub/sub channel through with patron and bartender communicate.
    def order_for(beer)
      [@pub_name, beer].join(':')
    end

    # The bar counter.
    def counter
      @counter ||= Pub.counter
    end

    private :order_for, :counter
  end
end
