class Pub
  class Patron
    attr_reader :key

    # Creates a new pub patron.
    #
    # Takes the name of the pub.
    def initialize(pub_name)
      @key = pub_name
    end

    # Orders one or more drinks at the bar counter.
    #
    # If given a block, yields the drinks as they become available. Otherwise,
    # returns all drinks when they are ready.
    def order(*drinks)
      channels, messages = [], []

      drinks.each do |value|
        redis.rpush(key, value)
        channels << [key, value].join(':')
      end

      redis.subscribe(*channels) do |on|
        on.message do |channel, message|
          redis.unsubscribe(channel)
          if block_given?
            yield message
          else
            messages << message
          end
        end
      end

      block_given? ? nil : messages
    end

    private

    def redis
      @redis ||= BarCounter.sub
    end
  end
end
