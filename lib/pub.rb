require "redis"
require "redis/connection/synchrony"

require "pub/helpers"

require "pub/bartender"
require "pub/house"
require "pub/patron"

# A pub with a non-blocking bar counter.
module Pub
  extend self

  # A device that dispenses beer.
  attr_accessor :beer_tap

  # A bar counter.
  def counter
    Redis.new(url: beer_tap)
  end

  # Enters a pub.
  #
  # Takes the name of the pub and an optional block.
  #
  #   Pub.enter('Ye Rubies') do |pub|
  #
  #     patron = pub.new_patron
  #
  #     patron.order('Guinness') do |beer|
  #       JSON.parse(beer).drink
  #     end
  #
  #   end
  #
  def enter(name)
    pub = House.new(name)

    if block_given?
      yield pub
    else
      pub
    end
  end
end
