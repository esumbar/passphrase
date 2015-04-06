require "passphrase"

module Passphrase
  RSpec.describe WordQuery, "queries the words table in a valid wordlist database" do
    before do
      wordlist_file = "../../lib/passphrase/wordlist/words.sqlite3"
      wordlist_path = File.join(File.dirname(__FILE__), wordlist_file)
      db = SQLite3::Database.new(wordlist_path, readonly: true)
      @words = WordQuery.new(db)
    end

    it "responds to the where() method with one argument" do
      expect(@words).to respond_to(:where).with(1).argument
    end

    context "#where([Hash])" do
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
end
