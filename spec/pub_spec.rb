require "spec_helper"

describe Pub do
  describe ".[]" do
    it "returns a queue object" do
        Pub["queue"].should be_a Pub::Queue
    end
  end

  describe ".redis" do
    it "returns a connection pool" do
      EM.synchrony do
        Pub.redis.should be_a EventMachine::Synchrony::ConnectionPool
        EM.stop
      end
    end
  end

  describe ".configure" do
    it "yields a block to configure system-wide settings" do
      expect {
        Pub.configure do |conf|
          conf.pool_size = 1
        end
      }.to change {
        Pub.send(:configuration).pool_size
      }.from(Pub::Configuration::DEFAULT_POOL_SIZE).to(1)
    end
  end
end
