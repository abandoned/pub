class Pub
  # The bar counter. This where patrons order drinks from bartenders.
  module BarCounter
    extend self

    attr_accessor :redis_url

    # What the bar patron sits on.
    def bar_stool
      Redis.new(url: redis_url)
    end

    # The device that dispenses ale.
    def handpump
      @handpump ||= Redis.new(url: redis_url)
    end

    # The device that dispenses beer.
    alias :beer_tap :handpump
  end
end
