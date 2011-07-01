require "spec_helper"

describe Pub do
  let(:pub) { Pub.new("Ye Olde Rubies") }

  describe ".counter" do
    it "returns a Redis connection" do
      Pub.counter.should be_a Redis
    end
  end

  describe "#new_bartender" do
    it "returns a new bartender" do
      pub.new_bartender.should be_a Pub::Bartender
    end
  end

  describe "#new_patron" do
    it "returns a new patron" do
      pub.new_patron.should be_a Pub::Patron
    end

    it "optionally deifnes the patron's patience" do
      patron = pub.new_patron(10)
      patron.patience.should eql 10
    end
  end
end
