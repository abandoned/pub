require "spec_helper"

describe Pub do
  include PubHelperMethods

  describe ".manage" do
    it "yields a block to manage the bar counter" do
      expect {
        Pub.manage do |counter|
          counter.redis_url = 'foo'
        end
      }.to change {
        Pub::BarCounter.redis_url
      }.to('foo')
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