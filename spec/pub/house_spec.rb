require "spec_helper"

module Pub
  describe House do
    subject { House.new("Ye Rubies") }

    describe "#new_bartender" do
      it "returns a new bartender" do
        subject.new_bartender.should be_a Pub::Bartender
      end
    end

    describe "#new_patron" do
      it "returns a new patron" do
        subject.new_patron.should be_a Pub::Patron
      end

      it "passes an optional hash to the new patron instance" do
        opts = {foo: 1}
        Patron.should_receive(:new).with(subject.name, opts)
        patron = subject.new_patron(opts)
      end
    end
  end
end
