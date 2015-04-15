require "sqlite3"
require "passphrase/diceware_random"
require "passphrase/language_query"
require "passphrase/word_query"

module Passphrase
  # This class implements the Diceware Method for generating a passphrase. It
  # selects words from a multi-language wordlist stored in an SQLite 3
  # database. A special {DicewareRandom} class is provided to work with this
  # class to simulate rolls of a die.
  class DicewareMethod
    # A convenience method for simultaneously creating a new DicewareMethod
    # object and calling {#run}
    # @return (see #run)
    def self.run(options)
      new(options).run
    end

    # @param options [Hash] the options passed from the {Passphrase} object
    def initialize(options)
      @number_of_words = options[:number_of_words]
      @random = DicewareRandom.new(options[:use_random_org])
      setup_database
      setup_queries
    end

    # Runs the Diceware method and returns its result to the calling
    # {Passphrase} object.
    # @return [Array<Array>] a three element array of the (1) random languages,
    #   (2) random die rolls, and (3) corresponding random words
    def run
      get_random_languages
      get_random_die_rolls
      select_words_from_wordlist
      [@random_languages, @random_die_rolls, @selected_words]
    end

    private

    def setup_database
      wordlist_file = "wordlist/words.sqlite3"
      wordlist_path = File.join(File.dirname(__FILE__), wordlist_file)
      raise "Wordlist database not found" unless File.exist?(wordlist_path)
      @db = SQLite3::Database.new(wordlist_path, readonly: true)
    end

    def setup_queries
      @languages = LanguageQuery.new(@db)
      @words = WordQuery.new(@db)
    end

    def get_random_languages
      @random_languages = @random.indices(@number_of_words, @languages.count)
      @random_languages.map! { |index| @languages[index] }
    end

    def get_random_die_rolls
      @random_die_rolls = @random.die_rolls(@number_of_words)
    end

    def select_words_from_wordlist
      @selected_words = []
      @random_languages.each_with_index do |language, index|
        die_rolls = @random_die_rolls[index]
        selection = @words.where(language: language, die_rolls: die_rolls)
        @selected_words << selection.split.sample
      end
    end
  end
end
