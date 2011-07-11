require "spec_helper"

module Pub
  describe Patron do
    let(:pub)     { Pub.enter("Ye Rubies") }
    let(:patron)  { pub.new_patron }

    describe "#order" do
      context "with a stubbed counter" do
        let(:counter) { double("Counter").as_null_object }

        before do
          patron.stub!(:counter).and_return(counter)
        end

        context "when ordering a beer" do
          let(:beer) { "Guinness" }

          after do
            patron.order(beer)
          end

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

          after do
            patron.order(*beers)
          end

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

          after do
            patron.order(beers)
          end

          it "splats the array and queues the beers at the counter" do
            beers.each do |beer|
              counter.should_receive(:rpush).with(pub.name, beer)
            end
          end
        end

        context "when the patron does not know what he or she wants" do
          it "raises an error" do
            expect do
              patron.order
            end.to raise_error ArgumentError
          end
        end
      end

      context "when the patron's patience runs out" do
        let(:beer)    { "Guinness" }
        let(:counter) { patron.send(:counter) }

        before do
          patron.patience = 0.1
        end

        after do
          patron.order(beer)
        end

        context "if no other patron has ordered the same beer" do
          it "removes the beer from the counter queue" do
            pending "Haven't figured out a way do this yet"
            counter.should_receive(:lrem).with(pub.name, 0, beer)
          end
        end

        context "if another patron has ordered the same beer" do
          it "does not remove the beer from the counter queue" do
            counter.should_not_receive(:lrem)
          end
        end
      end
    end
  end
end
