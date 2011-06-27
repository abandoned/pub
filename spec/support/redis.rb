RSpec.configure do |c|
  c.before(:each) do
    EM.synchrony { Pub.counter.flushall; EM.stop }
  end
end
