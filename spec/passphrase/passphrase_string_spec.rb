require "passphrase"

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

      it "responds to the to_password() method with zero arguments" do
        expect(@passphrase_string).to respond_to(:to_password).with(0).arguments
      end

      describe "#to_password" do
        before do
          @passwordized_string = @passphrase_string.to_password
        end

        it "returns an ordinary String" do
          expect(@passwordized_string).to be_an_instance_of(String)
        end

        it "returns a String that is not the same object as the PassphraseString" do
          expect(@passwordized_string).not_to equal(@passphrase_string)
        end

        it "returns a String that has the same length as the PassphraseString" do
          expect(@passwordized_string.length).to eq(@passphrase_string.length)
        end

        it "returns a String that contains at least one captial letter" do
          expect(@passwordized_string).to match(/[A-Z]/)
        end

        it "returns a String that contains at least one number" do
          expect(@passwordized_string).to match(/[0-9]/)
        end

        it "returns a String that contains at least one special character" do
          special_character = /[~!#\$%\^&\*\(\)\-=\+\[\]\\\{\}:;"'<>\?\/]/
          expect(@passwordized_string).to match(special_character)
        end
      end
    end
  end
end
