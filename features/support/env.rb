require "rubygems"
require "bundler/setup"

require "pub"

Around do |scenario, block|
  EM.synchrony do
    Pub.counter.flushall
    block.call
    EM.stop
  end
end
