RSpec.configure do |c|
  c.before(:each) do
    EM.synchrony { Pub.bar_counter.flushall; EM.stop }
  end
end
