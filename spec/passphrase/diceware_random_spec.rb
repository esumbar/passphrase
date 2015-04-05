require "passphrase"

module Passphrase
  RSpec.shared_examples "DicewareRandom object" do
    it "responds to the indices() method with 2 args" do
      expect(@random).to respond_to(:indices).with(2).arguments
    end

    it "responds to the die_rolls() method with 1 arg" do
      expect(@random).to respond_to(:die_rolls).with(1).arguments
    end

    it "does not respond to the setup_remote_generator() method (private)" do
      expect(@random).not_to respond_to(:setup_remote_generator)
    end

    it "does not respond to the setup_local_generator() method (private)" do
      expect(@random).not_to respond_to(:setup_local_generator)
    end

    it "does not respond to the generate_random_numbers() method (private)" do
      expect(@random).not_to respond_to(:generate_random_numbers)
    end

    it "does not respond to the group_die_rolls() method (private)" do
      expect(@random).not_to respond_to(:group_die_rolls)
    end

    describe "#indices(4, 15)" do
      before do
        @result = @random.indices(4, 15)
      end

      it "returns an array" do
        expect(@result).to be_an_instance_of(Array)
      end

      it "of size 4" do
        expect(@result.size).to eq(4)
      end

      it "all Fixnum items" do
        expect(@result).to all be_an_instance_of(Fixnum)
      end

      it "each one in the range 0...15" do
        expect(@result).to all be_between(0, 14)
      end
    end

    describe "#die_rolls(6)" do
      before do
        @result = @random.die_rolls(6)
      end

      it "returns an array" do
        expect(@result).to be_an_instance_of(Array)
      end

      it "of size 6" do
        expect(@result.size).to eq(6)
      end

      it "all String items" do
        expect(@result).to all be_an_instance_of(String)
      end

      it "each one five characters long" do
        expect(@result.map(&:length)).to all eq(5)
      end

      it "that match the pattern /^[123456]+$/" do
        expect(@result).to all match(/^[123456]+$/)
      end
    end
  end

  RSpec.describe DicewareRandom, "generates and formats arrays of random numbers" do
    it "responds to the attribute reader method random_org_requests()" do
      expect(DicewareRandom).to respond_to(:random_org_requests)
    end

    context "initialized by default to use the local Ruby random number generator" do
      before do
        @random = DicewareRandom.new
      end
      
      include_examples "DicewareRandom object"
    end

    context "initialized to use random numbers from RANDOM.ORG" do
      before do
        @random = DicewareRandom.new(:use_random_org)
      end

      it "initially has a zero random.org request count" do
        expect(DicewareRandom.random_org_requests).to eq(0)
      end

      it "increments the random.org request count on indices()" do
        expect {
          @random.indices(4, 15)
          }.to change(DicewareRandom, :random_org_requests).by(1)
      end

      it "increments the RANDOM.ORG request count on die_rolls()" do
        expect {
          @random.die_rolls(4)
          }.to change(DicewareRandom, :random_org_requests).by(1)
      end

      it "does not respond to the check_random_org_quota() method (private)" do
        expect(@random).not_to respond_to(:check_random_org_quota)
      end

      it "raises an exception when a network error occurs (e.g. wrong address)" do
        @random.instance_eval { @random_org_uri = "https://www.randomx.org" }
        expect { @random.indices(4, 15) }.to raise_error
      end
        
      include_examples "DicewareRandom object"
    end
  end
end
