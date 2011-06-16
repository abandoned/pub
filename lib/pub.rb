begin
  require "yajl"
rescue LoadError
  require "json"
end
require "redis"
require "redis/connection/synchrony"

require "pub/bar_counter"
require "pub/bartender"
require "pub/patron"

# A Redis-backed pub with a non-blocking bar counter.
class Pub
  # The name of the pub.
  attr_reader :name

  class << self
    # Manages the bar counter.
    #
    #   Pub.manage do |counter|
    #     counter.redis_url = 'redis://localhost:6379'
    #   end
    #
    def manage
      yield BarCounter
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
  #       # chug beer
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
