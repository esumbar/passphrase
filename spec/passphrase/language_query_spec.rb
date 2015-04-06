require "passphrase"

module Passphrase
  RSpec.describe LanguageQuery, "queries the languages table in a valid wordlist database" do
    before do
      wordlist_file = "../../lib/passphrase/wordlist/words.sqlite3"
      wordlist_path = File.join(File.dirname(__FILE__), wordlist_file)
      db = SQLite3::Database.new(wordlist_path, readonly: true)
      @languages = LanguageQuery.new(db)
    end

    it "responds to the count() method with no arguments" do
      expect(@languages).to respond_to(:count).with(0).arguments
    end

    it "responds to the []() method with one argument" do
      expect(@languages).to respond_to(:[]).with(1).argument
    end

    context "#count" do
      before do
        @count = @languages.count
      end

      it "returns an integer" do
        expect(@count).to be_an_instance_of(Fixnum)
      end

      it "greater than zero" do
        expect(@count).to be > 0
      end
    end

    context "#[](0)" do
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
  end
end
