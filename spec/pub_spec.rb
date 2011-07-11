require "spec_helper"

describe Pub do
  describe ".counter" do
    it "returns a Redis connection" do
      subject.counter.should be_a Redis
    end
  end

  describe ".enter" do
    it "returns a new public house" do
      Pub.enter('foo').should be_a Pub::House
    end

    context "when given a block" do
      it "yields the public house to the block" do
        capture = nil
        Pub.enter('foo') { |pub| capture = pub }
        capture.should be_a Pub::House
      end
    end
  end
end
