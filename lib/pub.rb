require "redis"
require "redis/connection/synchrony"

require "pub/helpers"

require "pub/bartender"
require "pub/house"
require "pub/patron"

# A Redis-backed pub with a non-blocking bar counter.
#
# Or, putting aside the metaphor for a moment:
#
# A processing queue where consumers, instead of simply queuing jobs and
# getting on with their lives, queue and wait for a response without
# blocking the Ruby process.
#
# Each public house is a distinct queue.
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
  #   Pub.enter('Ye Olde Rubies') do |pub|
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
    House.new(name)
  end
end
