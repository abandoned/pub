require "spec_helper"

describe Pub do
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

  context "given a pub" do
    describe "#new_bartender" do
      it "returns a new bartender" do
        Pub.new('Ye Olde Rubies') do |pub|
          pub.new_bartender.should be_a Pub::Bartender
          pub.close
        end
      end
    end

    describe "#new_patron" do
      it "returns a new patron" do
        Pub.new('Ye Olde Rubies') do |pub|
          pub.new_patron.should be_a Pub::Patron
          pub.close
        end
      end
    end
  end
end
