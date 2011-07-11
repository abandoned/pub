require "spec_helper"

module Pub
  describe Bartender do
    let(:pub)       { Pub.enter("Ye Rubies") }
    let(:bartender) { pub.new_bartender }
    let(:counter)   { double("Counter").as_null_object }

    before do
      bartender.stub!(:counter).and_return(counter)
    end

    describe "#take_order" do
      before do
        counter.stub!(:lpop).and_return(Time.now)
      end

      context "when not passed a number" do
        it "pops one order from the queue" do
          orders = bartender.take_orders
          orders.count.should eql 1
        end
      end

      context "when passed a number" do
        it "returns that many orders from the queue" do
          orders = bartender.take_orders(3)
          orders.count.should eql 3
        end
      end
    end

    describe "#serve" do
      let(:beer) { "Guinness" }

      after do
        bartender.serve(beer) { beer }
      end

      it "removes duplicate instances of the beer from the queue" do
        counter.should_receive(:lrem).with(pub.name, 0, beer)
      end

      it "publishes the order" do
        order = bartender.send(:order_for, beer)
        counter.should_receive(:publish).with(order, beer)
      end
    end
  end
end
