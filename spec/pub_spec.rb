require "spec_helper"

describe Pub do
  describe ".counter" do
    it "returns a Redis connection" do
      subject.counter.should be_a Redis
    end
  end
end
