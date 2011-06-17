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
    # If given a block, yields the drinks as they become available. Otherwise,
    # returns all drinks when they are ready.
    def order(*drinks)
      orders, glasses = [], []

      drinks.each do |drink|
        bar_stool.rpush(pub_name, drink)
        orders << [pub_name, drink].join(':')
      end

      bar_stool.subscribe(*orders) do |on|
        on.message do |order, glass|
          bar_stool.unsubscribe(order)
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

    def bar_stool
      @bar_stool ||= BarCounter.bar_stool
    end
  end
end
