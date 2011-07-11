require "rubygems"
require "bundler/setup"

require "ruby-debug"

require "pub"

Around do |scenario, block|
  EM.synchrony do
    Pub.counter.flushall
    block.call
    EM.stop
  end
end
