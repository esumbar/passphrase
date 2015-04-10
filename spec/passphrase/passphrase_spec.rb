require "passphrase"

module Passphrase
  RSpec.describe Passphrase, "for generating passphrase objects" do
    it "yields itself during instantiation" do
      expect { |b| Passphrase.new(Default.options, &b) }.to yield_with_args(Passphrase)
    end

    # Dependence on RANDOM.ORG only affects the DicewareRandom class.
    # Therefore, only need to test the case where RANDOM.ORG is not used.
    context "initialized to generate a passphrase with 1 word, not using RANDOM.ORG" do
      before do
        @passphrase = Passphrase.new(number_of_words: 1, use_random_org: nil)
      end

      it "responds to the generate() method with zero arguments" do
        expect(@passphrase).to respond_to(:generate).with(0).arguments
      end

      it "responds to the to_s() method" do
        expect(@passphrase).to respond_to(:to_s)
      end

      it "responds to the inspect() method with zero arguments" do
        expect(@passphrase).to respond_to(:inspect).with(0).arguments
      end

      it "responds to attribute reader method passphrase()" do
        expect(@passphrase).to respond_to(:passphrase)
      end

      it "responds to predicate method using_random_org?()" do
        expect(@passphrase).to respond_to(:using_random_org?)
      end

      it "responds to attribute reader method number_of_words()" do
        expect(@passphrase).to respond_to(:number_of_words).with(0).arguments
      end

      it "does not respond to the word_origins() method (private)" do
        expect(@passphrase).not_to respond_to(:word_origins)
      end

      it "initially contains an empty passphrase string" do
        expect(@passphrase.passphrase).to be_empty
      end

      it "should not be using RANDOM.ORG" do
        expect(@passphrase).not_to be_using_random_org
      end

      context "after executing the generate() method" do
        before do
          dwr = [["language"], ["11111"], ["passphrase"]]
          allow(DicewareMethod).to receive(:run).and_return(dwr)
          @result = @passphrase.generate
        end

        it "returns itself" do
          expect(@result).to equal(@passphrase)
        end

        it "contains the passphrase string" do
          expect(@result.passphrase).to eq("passphrase")
        end

        it "contains a number of words equal to one" do
          expect(@result.number_of_words).to eq(1)
        end

        it "returns the passphrase when printed" do
          sio = StringIO.new("")
          $stdout = sio
          expect { puts @result }.to change { sio.string.chomp }
            .from("").to(@result.passphrase)
        end

        it "can be inspected" do
          expect(@result.inspect).to match(
            passphrase: "passphrase",
            number_of_words: 1,
            use_random_org: nil,
            word_origins: { "passphrase" => {
              language: "language",
              die_rolls: "11111"
              }
            }
          )
        end
      end
    end

    context "initialized to use RANDOM.ORG" do
      it "the predicate method should confirm it is using RANDOM.ORG" do
        passphrase = Passphrase.new(number_of_words: 3, use_random_org: true)
        expect(passphrase).to be_using_random_org
      end
    end

    context "initialized with default options" do
      before do
        @passphrase = Passphrase.new
        @passphrase.generate
      end

      it "return a passphrase with the default number of words" do
        expect(@passphrase.number_of_words).to eq(Default.options[:number_of_words])
      end

      it "should not be using RANDOM.ORG" do
        expect(@passphrase).not_to be_using_random_org
      end
    end
  end
end
