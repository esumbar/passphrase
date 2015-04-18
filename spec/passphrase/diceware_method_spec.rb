require "passphrase"

module Passphrase
  RSpec.describe DicewareMethod, "implements the Diceware method" do
    it "responds to the class method run() with one argument" do
      expect(DicewareMethod).to respond_to(:run).with(1).argument
    end

    context "initialized with default options" do
      before do
        @diceware = DicewareMethod.new(Default.options)
      end
      
      it "responds to the run() method with no arguments" do
        expect(@diceware).to respond_to(:run)
      end

      it "does not respond to the get_random_languages() method (private)" do
        expect(@diceware).not_to respond_to(:get_random_languages)
      end

      it "does not respond to the get_random_random_die_rolls() method (private)" do
        expect(@diceware).not_to respond_to(:get_random_random_die_rolls)
      end

      it "does not respond to the select_words_from_wordlist() method (private)" do
        expect(@diceware).not_to respond_to(:select_words_from_wordlist)
      end

      describe "#run" do
        before do
          @result = @diceware.run
        end

        it "returns an array of three arrays" do
          expect(@result).to contain_exactly(
            an_instance_of(Array),
            an_instance_of(Array),
            an_instance_of(Array)
          )
        end

        it "each array contains the default number of words elements" do
          @result.each do |result|
            expect(result.size).to eq(Default.options[:number_of_words])
          end
        end

        it "each array contains String elements" do
          @result.each do |result|
            result.each do |element|
              expect(element).to be_an_instance_of(String)
            end
          end
        end
      end
    end
  end
end
