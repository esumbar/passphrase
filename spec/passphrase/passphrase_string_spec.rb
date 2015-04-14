require "passphrase/passphrase_string"
require "passphrase/diceware_random"

module Passphrase
  RSpec.describe PassphraseString, "subclass of String class" do
    context "initialized with a sample string" do
      before do
        @sample = "a sample passphrase string"
        @passphrase_string = PassphraseString.new(@sample, false)
      end
      
      it "contains the same string as the sample string" do
        expect(@passphrase_string).to eq(@sample)
      end

      it "has the same length as the sample string" do
        expect(@passphrase_string.length).to eq(26)
      end

      it "responds to the passwordize() method with zero arguments" do
        expect(@passphrase_string).to respond_to(:passwordize).with(0).arguments
      end

      context "#passwordize" do
        before do
          @passwordized_string = @passphrase_string.passwordize
        end

        it "returns a PassphraseString" do
          expect(@passwordized_string).to be_an_instance_of(PassphraseString)
        end

        it "is not the same object as self" do
          expect(@passwordized_string).not_to equal(@passphrase_string)
        end

        it "has the same length as self" do
          expect(@passwordized_string.length).to eq(@passphrase_string.length)
        end

        it "contains at least one captial letter" do
          expect(@passwordized_string).to match(/[A-Z]/)
        end

        it "contains at least one number" do
          expect(@passwordized_string).to match(/[0-9]/)
        end

        it "contains at least one special character" do
          special_character = /[~!#\$%\^&\*\(\)\-=\+\[\]\\\{\}:;"'<>\?\/]/
          expect(@passwordized_string).to match(special_character)
        end

        it "does not produce different results when called multiple times" do
          expect(@passwordized_string.passwordize).to eq(@passwordized_string)
        end
      end
    end
  end
end
