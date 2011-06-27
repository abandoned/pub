require "spec_helper"

describe Pub do
  include PubStubbers

  describe ".counter" do
    it "returns a Redis connection" do
      Pub.counter.should be_a Redis
    end

    it "caches that Redis connection" do
      Redis.should_not_receive :new
      Pub.counter
    end
  end

  describe ".stool" do
    it "returns a Redis connection" do
      Pub.stool.should be_a Redis
    end

    it "does not cache that Redis connection" do
      Redis.should_receive(:new).once
      Pub.stool
    end
  end

  describe "#new_bartender" do
    it "returns a new bartender" do
      enter_pub do |pub|
        pub.new_bartender.should be_a Pub::Bartender
      end
    end
  end

  describe "#new_patron" do
    it "returns a new patron" do
      enter_pub do |pub|
        pub.new_patron.should be_a Pub::Patron
      end
    end
  end
end
