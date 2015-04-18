require "passphrase"

module Passphrase
  RSpec.describe WordlistDatabase, "Diceware wordlist database class" do
    before do
      @db = WordlistDatabase.connect
    end

    describe "#from(:languages)" do
      it "returns a Language object" do
        expect(@db.from(:languages)).to be_an_instance_of(Language)
      end
    end

    describe "#[:languages]" do
      it "returns a Language object" do
        expect(@db[:languages]).to be_an_instance_of(Language)
      end
    end

    describe "#from(:words)" do
      it "returns a Word object" do
        expect(@db.from(:words)).to be_an_instance_of(Word)
      end
    end

    describe "#[:words]" do
      it "returns a Word object" do
        expect(@db[:words]).to be_an_instance_of(Word)
      end
    end

    describe "#from(:nonexistant)" do
      it "raises an error" do
        expect { @db.from(:nonexistant) }.to raise_error("Unknown table nonexistant")
      end
    end
  end

  RSpec.describe Word, "queries the words table in a valid wordlist database" do
    before do
      @words = WordlistDatabase.connect.from(:words)
    end

    it "responds to the where() method with one argument" do
      expect(@words).to respond_to(:where).with(1).argument
    end

    describe "#where([Hash])" do
      before do
        @selection = @words.where(language: "afrikaans", die_rolls: "11111")
      end

      it "returns a string" do
        expect(@selection).to be_an_instance_of(String)
      end

      it "that is not empty" do
        expect(@selection).not_to be_empty
      end
    end
  end

  RSpec.describe Language, "queries the languages table in a valid wordlist database" do
    before do
      @languages = WordlistDatabase.connect.from(:languages)
    end

    it "responds to the count() method with no arguments" do
      expect(@languages).to respond_to(:count).with(0).arguments
    end

    it "responds to the []() method with one argument" do
      expect(@languages).to respond_to(:[]).with(1).argument
    end

    it "responds to the all() method with no arguments" do
      expect(@languages).to respond_to(:all).with(0).arguments
    end

    it "responds to the only() method with one argument" do
      expect(@languages).to respond_to(:only).with(1).argument
    end

    it "does not respond to the validate() method (private)" do
      expect(@languages).not_to respond_to(:validate)
    end

    describe "#count" do
      it "returns 15" do
        expect(@languages.count).to eq(15)
      end
    end

    describe "#[](0)" do
      before do
        @language = @languages[0]
      end

      it "returns a string" do
        expect(@language).to be_an_instance_of(String)
      end

      it "that is not empty" do
        expect(@language).not_to be_empty
      end
    end

    describe "#all" do
      before do
        @result = @languages.all
      end

      it "returns an array" do
        expect(@result).to be_an_instance_of(Array)
      end

      it "with 15 elements" do
        expect(@result.size).to eq(15)
      end

      it "of all strings" do
        expect(@result).to all be_an_instance_of(String)
      end
    end

    describe "#only([\"e\", \"fr\"])" do
      before do
        @languages.only(["e", "fr"])
      end

      it "produces a count of 2" do
        expect(@languages.count).to eq(2)
      end

      it "returns only english and french" do
        expect(@languages.all).to eq(%w( english french ))
      end
    end

    describe "#only([\"zz\"])" do
      it "raises an error" do
        expect { @languages.only(["zz"]) }.to raise_error("No language match for zz")
      end
    end
  end
end
