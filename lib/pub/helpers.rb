module Pub
  # Methods used by both patron and bartender.
  module Helpers
    def leave
      counter.quit
      @counter = nil
    end

    def counter
      @counter ||= Pub.counter
    end

    def order_for(beer)
      [@pub_name, beer].join(':')
    end

    private :order_for, :counter
  end
end
