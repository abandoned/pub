require "rubygems"
require "bundler/setup"
require "rspec"

require File.expand_path("../../lib/pub", __FILE__)

RSpec.configure do |c|
  c.around(:each) do |example|
    EM.synchrony do
      Pub.counter.flushall
      example.run
      EM.stop
    end
  end
end
