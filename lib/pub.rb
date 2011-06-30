require "redis"
require "redis/connection/synchrony"

require "pub/helpers"
require "pub/bartender"
require "pub/patron"

# A Redis-backed pub with a non-blocking bar counter.
#
# Or, putting aside the metaphor for a moment:
#
# A processing queue where consumers, instead of simply queuing jobs and
# getting on with their lives, queue and wait for a response without
# blocking the Ruby process.
#
# Each pub instance is a distinct queue.
class Pub
  # The name of the pub.
  attr_reader :name

  class << self
    # A device that dispenses beer.
    attr_accessor :beer_tap

    # The bar counter.
    def counter
      Redis.new(url: beer_tap)
    end
  end

  # Enters a pub.
  #
  # Takes the name of the pub and an optional block.
  #
  #   Pub.new('Ye Olde Rubies') do |pub|
  #
  #     patron = pub.new_patron
  #
  #     patron.order('Guinness') do |beer|
  #       JSON.parse(beer).drink
  #     end
  #
  #   end
  #
  def initialize(name)
    @name = name
    EM.synchrony { yield self } if block_given?
  end

  # Closes the pub for the night.
  def close
    EM.stop
  end

  # A new bartender.
  def new_bartender
    Bartender.new(name)
  end

  # A new patron.
  def new_patron(timeout = 5)
    Patron.new(name, timeout)
  end
end
