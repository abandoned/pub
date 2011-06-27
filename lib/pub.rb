require "redis"
require "redis/connection/synchrony"

require "pub/bartender"
require "pub/patron"

# A Redis-backed pub with a non-blocking bar counter.
class Pub
  # The name of the pub.
  attr_reader :name

  class << self
    # A device that dispenses beer.
    attr_accessor :beer_tap

    # Where beers are served.
    def counter
      @counter ||= Redis.new(url: beer_tap)
    end

    # What a patron sits on.
    def stool
      Redis.new(url: beer_tap)
    end
  end

  # Enters a pub.
  #
  # Takes the name of the pub and a block.
  #
  #   Pub.new('Ye Olde Rubies') do |pub|
  #
  #     patron    = pub.new_patron
  #     bartender = pub.new_bartender
  #
  #     patron.order('1 pint of guinness') do |beer|
  #       # consume beer
  #     end
  #
  #     bartender.serve(10) do |beer|
  #       take_payment(beer)
  #     end
  #
  #   end
  #
  def initialize(name)
    @name = name
    EM.synchrony { yield self }
  end

  # Closes the pub for the night.
  def close
    EM.stop
  end

  # Conjures a new bartender.
  def new_bartender
    Bartender.new(name)
  end

  # Conjures a new patron.
  def new_patron
    Patron.new(name)
  end
end
