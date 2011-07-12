require "redis"
require "redis/connection/synchrony"

require "pub/helpers"

require "pub/bartender"
require "pub/house"
require "pub/patron"

# A pub.
module Pub
  extend self

  # A device that dispenses beer.
  attr_accessor :beer_tap

  # A non-blocking bar counter.
  def counter
    Redis.new(url: beer_tap)
  end

  # Enters a pub.
  #
  # Takes the name of the pub and an optional block.
  def enter(name)
    pub = House.new(name)

    if block_given?
      EM.synchrony { yield pub } if block_given?
    else
      pub
    end
  end
end
