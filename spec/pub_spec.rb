require "spec_helper"

describe Pub do
  include PubStubbers

  describe ".bar_counter" do
    it "returns a Redis connection" do
      Pub.bar_counter.should be_a Redis
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
