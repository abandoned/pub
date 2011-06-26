require "spec_helper"

class Pub
  describe Patron do
    include PubHelperMethods

    describe "#order" do
      it "orders a drink" do
        enter_pub do |pub|
          drink   = 'Guinness'
          patron  = pub.new_patron

          glasses = stub_bartender(pub, drink) { patron.order(drink) }

          glasses.first.should eql 'A pint of Guinness'
          Pub.counter.rpop(pub.name).should eql drink
        end
      end

      it "orders a few drinks" do
        enter_pub do |pub|
          drinks  = %w{Guinness Stella}
          patron  = pub.new_patron

          glasses = stub_bartender(pub, *drinks) { patron.order(*drinks) }

          glasses.should =~ ['A pint of Guinness', 'A pint of Stella']
          2.times.map { Pub.counter.rpop(pub.name) }.should =~ drinks
        end
      end

      it "receives nothing when he cannot make up his mind" do
        enter_pub do |pub|
          drinks  = []
          patron  = pub.new_patron

          glasses = stub_bartender(pub, *drinks) { patron.order(*[]) }

          glasses.should be_empty
        end

      end
      # context "given no channels" do
      # end

      # context "when a subscription times out" do
      #   before do
      #     subscriber.stub!(:channels).and_return(['foo'])
      #   end
      # end
    end
  end
end
