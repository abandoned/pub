require "spec_helper"

module Pub
  describe House do
    subject { House.new("Ye Olde Rubies") }

    describe "#new_bartender" do
      it "returns a new bartender" do
        subject.new_bartender.should be_a Pub::Bartender
      end
    end

    describe "#new_patron" do
      it "returns a new patron" do
        subject.new_patron.should be_a Pub::Patron
      end

      it "optionally defines the patron's patience" do
        patron = subject.new_patron(10)
        patron.patience.should eql 10
      end
    end
  end
end
