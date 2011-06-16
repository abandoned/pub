class Pub
  module BarCounter
    extend self

    attr_accessor :redis_url

    def pub
      Redis.new(url: redis_url)
    end

    def store
      Redis.new(url: redis_url)
    end

    def stool
      Redis.new(url: redis_url)
    end
  end
end
