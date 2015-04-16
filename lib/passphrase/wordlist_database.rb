require "sqlite3"

module Passphrase
  # This class encapsulates the {#count} and {#[]} queries against the
  # "languages" table in the "words" SQLite 3 database. It also provides the
  # {#only} method which allows a subset of languages to be specified.
  class Language
    def initialize(db)
      @languages = []
      sql = "SELECT language FROM languages"
      db.execute(sql).each { |lang| @languages << lang.first }
    end
    
    # @return [Integer] the number of rows in the languages table
    def count
      @languages.size
    end

    # @param index [Integer] selects a specific row in the languages table
    # @return [String] the language corresponding to the given index
    def [](index)
      @languages[index]
    end

    # @return [Array] all rows in the languages table
    def all
      @languages
    end

    # @param language_list [Array] restrict languages to those in the list
    # @return [self] to allow chaining methods
    def only(language_list)
      return self if /^all$/ =~ language_list.first
      validate(language_list)
      @languages.keep_if do |language|
        language_list.any? { |l| language.match("^#{l}") }
      end
      self
    end

    private

    # Make sure that each language specification matches at least one
    # language.
    def validate(language_list)
      language_list.each do |l|
        matches_language = @languages.any? { |language| language.match("^#{l}") }
        raise "No language match for \"#{l}\"" unless matches_language
      end
    end
  end
  # This class encapsulates the {#where} query against the "words" table in
  # the "words" SQLite 3 database. The filter parameter must be a hash that
  # specifies a language and sequence of die rolls.
  # @example
  #   {language: "afrikaans", die_rolls: "11111"}
  class Word
    def initialize(db)
      @db = db
    end

    # @param filter [Hash] specifies the language/die_roll combination
    # @return [String] a string of space-separated words from the wordlist
    def where(filter)
      sql = "SELECT words " + 
            "FROM words " + 
            "WHERE language = :language AND die_rolls = :die_rolls"
      @db.get_first_value(sql, filter)
    end
  end
  # This class encapsulates the Diceware wordlist database file and dispatches
  # one of two table query objects via the {#from} method.
  class WordlistDatabase
    # A "connect" method seems more natural than "new" when connecting to a
    # database.
    def self.connect
      new
    end

    def initialize
      wordlist_file = "wordlist/words.sqlite3"
      wordlist_path = File.join(File.dirname(__FILE__), wordlist_file)
      raise "Wordlist database file not found" unless File.exist?(wordlist_path)
      @db = SQLite3::Database.new(wordlist_path, readonly: true)
    end

    # @param table [Symbol] the table name
    # @return [Language] if the "languages" table is specified
    # @return [Word] if the "words" table is specified
    def from(table)
      case table
      when :languages
        Language.new(@db)
      when :words
        Word.new(@db)
      else
        raise "Unknown table"
      end
    end

    alias [] from
  end
end
