class Pub
  class Patron
    attr_reader :pub_name

    # Creates a new pub patron.
    #
    # Takes the name of the pub.
    def initialize(pub_name)
      @pub_name = pub_name
    end

    # Orders one or more drinks at the bar counter.
    #
    # If given a block, yields glasses as they become available. Otherwise,
    # returns all glasses when they are ready.
    def order(*drinks)
      orders, glasses = [], []

      drinks.each do |drink|
        Pub.counter.rpush(pub_name, drink)
        orders << [pub_name, drink].join(':')
      end

      stool.subscribe(*orders) do |on|
        on.message do |order, glass|
          stool.unsubscribe(order)
          if block_given?
            yield glass
          else
            glasses << glass
          end
        end
      end

      block_given? ? nil : glasses
    end

    private

    def stool
      @stool ||= Pub.stool
    end
  end
end
