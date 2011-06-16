require "rubygems"
require "bundler/setup"
require "rspec"

require File.expand_path("../../lib/pub", __FILE__)

def enter_pub
  Pub.new('Ye Olde Rubies') do |pub|
    yield pub
    pub.close
  end
end
