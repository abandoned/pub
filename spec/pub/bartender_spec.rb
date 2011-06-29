require "spec_helper"

class Pub
  describe Bartender do
    include PubStubbers

    describe "#take_order" do
      it "takes one or more orders to fill" do
        enter_pub do |pub|
          bartender = pub.new_bartender
          stub_orders(pub, 'Guinness', 'Stella', '1664')
          bartender.take_orders(2).should =~ ['Guinness', 'Stella']
          bartender.take_orders(2).should eql ['1664']
        end
      end
    end

    describe "#serve" do
      it "serves a drink" do
        orders = ["Guinness", "Stella"]
        drinks = Array.new

        enter_pub do |pub|
          bartender = pub.new_bartender
          counter = bartender.send(:bar_counter)
          counter.should_receive(:publish).once.with("Ye Olde Rubies:Guinness", "A pint of Guinness")
          counter.should_receive(:publish).once.with("Ye Olde Rubies:Stella", "A pint of Stella")
          orders.each do |order|
            bartender.serve(order) { "A pint of #{order}" }
          end
        end
      end
    end
  end
end
