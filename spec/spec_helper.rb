require "rubygems"
require "bundler/setup"
require "rspec"

require File.expand_path("../../lib/pub", __FILE__)

module PubHelperMethods
  def enter_pub
    Pub.new('Ye Olde Rubies') do |pub|
      yield pub
      pub.close
    end
  end

  def stub_bartender(pub, *drinks)
    EM.add_timer(0.05) do
      Fiber.new do
        counter = Pub.counter
        drinks.each do |drink|
          counter.publish([pub.name, drink].join(':'), "A pint of #{drink}")
        end
      end.resume
    end
    yield
  end
end
