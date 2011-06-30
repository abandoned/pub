require "spec_helper"

class Pub
  describe Patron do
    let(:pub)     { Pub.new("Ye Olde Rubies") }
    let(:patron)  { pub.new_patron }
    let(:counter) { double("Counter").as_null_object }

    before do
      patron.stub!(:counter).and_return(counter)
    end

    describe "#order" do
      context "when ordering a beer" do
        let(:beer) { "Guinness" }
        after      { patron.order(beer) }

        it "queues the beer at the counter" do
          counter.should_receive(:rpush).with(pub.name, beer)
        end

        it "subscribes to the order" do
          order = patron.send(:order_for, beer)
          counter.should_receive(:subscribe).with(order)
        end
      end

      context "when ordering two beers" do
        let(:beers) { ["Guinness", "Stella"] }
        after       { patron.order(*beers) }

        it "queues the beers at the counter" do
          beers.each do |beer|
            counter.should_receive(:rpush).with(pub.name, beer)
          end
        end

        it "subscribes to the orders" do
          orders = beers.map do |beer|
            patron.send(:order_for, beer)
          end
          counter.should_receive(:subscribe).with(*orders)
        end
      end

      context "when ordering an array of beers" do
        let(:beers) { ["Guinness", "Stella"] }
        after       { patron.order(beers) }

        it "splats the array and queues the beers at the counter" do
          beers.each do |beer|
            counter.should_receive(:rpush).with(pub.name, beer)
          end
        end
      end

      context "when patron does not know what he or she wants" do
        it "raises an error" do
          expect do
            patron.order
          end.to raise_error ArgumentError
        end
      end
    end
  end
end
