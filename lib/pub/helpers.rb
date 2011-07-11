module Pub
  # Methods used by both patron and bartender.
  module Helpers
    # The bar counter.
    def counter
      @counter ||= Pub.counter
    end

    # Leave the counter.
    def leave
      counter.quit
    end

    # A specific order.
    #
    # This is a pub/sub channel through with patron and bartender communicate.
    def order_for(beer)
      [@pub_name, beer].join(':')
    end

    private :order_for, :counter
  end
end
