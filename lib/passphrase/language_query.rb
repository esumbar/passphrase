module Passphrase
  # This class encapsulates the {#count} and {#[]} queries against the
  # "languages" table in the "words" SQLite 3 database.
  class LanguageQuery
    def initialize(db)
      @db = db
    end
    
    # @return [Integer] the number of rows in the languages table
    def count
      sql = "SELECT COUNT(*) AS count FROM languages"
      @db.get_first_value(sql)
    end

    # @param index [Integer] selects a specific row in the languages table
    # @return [String] the language corresponding to the given index
    def [](index)
      sql = "SELECT language FROM languages"
      unless @languages
        @languages = []
        @db.execute(sql).each { |lang| @languages << lang.first }
      end
      @languages[index]
    end
  end
end
