module Passphrase
  # This class encapsulates the {#where} query against the "words" table in
  # the "words" SQLite 3 database. The filter parameter must be a hash that
  # specifies a language and sequence of die rolls.
  # @example
  #   {language: "afrikaans", die_rolls: "11111"}
  class WordQuery
    def initialize(db)
      @db = db
    end

    # @param filter [Hash] specifies the language/die_roll combination
    # @return [String] the selected words from the wordlist
    def where(filter)
      sql = "SELECT words " + 
            "FROM words " + 
            "WHERE language = :language AND die_rolls = :die_rolls"
      @db.get_first_value(sql, filter)
    end
  end
end
