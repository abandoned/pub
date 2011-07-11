require "spec_helper"

module Pub
  describe House do
    subject { House.new("Ye Rubies") }

    describe "#new_bartender" do
      it "returns a new bartender" do
        subject.new_bartender.should be_a Bartender
      end
    end

    describe "#new_patron" do
      it "returns a new patron" do
        subject.new_patron.should be_a Patron
      end

      it "passes an optional hash to the new patron instance" do
        opts = {foo: 1}
        Patron.should_receive(:new).with(subject.name, opts)
        patron = subject.new_patron(opts)
      end

      context "when given a block" do
        it "yields patron to the block" do
          capture = nil
          subject.new_patron { |patron| capture = patron }
          capture.should be_a Patron
        end

        it "closes the Redis connection once block has run" do
          subject.new_patron do |patron|
            patron.should_receive :leave
          end
        end
      end
    end
  end
end
