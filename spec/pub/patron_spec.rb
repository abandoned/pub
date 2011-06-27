require "spec_helper"

class Pub
  describe Patron do
    include PubStubbers

    describe "#order" do
      context "when ordering one drink" do
        it "places an order at the counter" do
          enter_pub do |pub|
            patron  = pub.new_patron
            stub_service(pub, 'Guinness')
            drinks = patron.order('Guinness')
            drinks.should eql ['A pint of Guinness']
          end
        end
      end

      context "when ordering a few drinks" do
        it "places an order at the counter" do
          enter_pub do |pub|
            patron  = pub.new_patron
            stub_service(pub, 'Guinness', 'Stella')
            drinks = patron.order('Guinness', 'Stella')
            drinks.should =~ ['A pint of Guinness', 'A pint of Stella']
          end
        end
      end

      context "when bartender does not prepare a drink on time" do
        it "picks up whatever is there" do
          enter_pub do |pub|
            patron = pub.new_patron
            patron.waits_no_more_than 0.5
            stub_service(pub, 'Guinness')
            drinks = patron.order('Guinness', 'Stella')
            drinks.should eql ['A pint of Guinness']
          end
        end
      end

      context "when patron does not know what he wants" do
        it "raises an error" do
          expect do
            enter_pub do |pub|
              patron  = pub.new_patron
              patron.order
            end.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
