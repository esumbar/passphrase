require "sqlite3"

module Passphrase
  class DatabaseHelper

    def self.list_languages(raw_data_dir)
      count = 0
      Dir[File.join(raw_data_dir, "*.txt")].each do |file|
        if /(?<lang>\w+)-(dice|wordlist)/ =~ File.basename(file, ".txt")
          count += 1
          puts "#{count.to_s.rjust(4)}. #{lang.downcase.capitalize}"
        end
      end        
    end

    def initialize(database_file, raw_data_dir)
      @database_file = database_file
      setup_database_vars(database_file)
      setup_language_vars(raw_data_dir)
    end

    def fresh_setup
      clean_database
      create_database
      insert_database
    end

    def clean_database
      drop_languages_table
      drop_words_table
      drop_language_die_rolls_index
    end

    def create_database
      create_languages_table
      create_words_table
    end

    def insert_database
      insert_languages
      insert_words
      create_language_die_rolls_index
    end

    private

    def setup_database_vars(database_file)
      @db = SQLite3::Database.new(database_file)
    end

    def setup_language_vars(raw_data_dir)
      @languages = []
      @language_files = {}
      Dir[File.join(raw_data_dir, "*.txt")].each do |file|
        if /(?<lang>\w+)-(dice|wordlist)/ =~ File.basename(file, ".txt")
          language = lang.downcase
          @languages << language
          @language_files[language] = file
        end
      end    
    end

    def drop_languages_table
      sql = "DROP TABLE IF EXISTS languages"
      @db.execute sql
    end

    def drop_words_table
      sql = "DROP TABLE IF EXISTS words"
      @db.execute sql
    end

    def drop_language_die_rolls_index
      sql = "DROP INDEX IF EXISTS language_die_rolls"
      @db.execute sql
    end

    def create_languages_table
      sql = "CREATE TABLE languages (language TEXT)"
      @db.execute sql
    end

    def create_words_table
      sql = "CREATE TABLE words " +
      "(language TEXT, die_rolls TEXT, words TEXT)"
      @db.execute sql
    end

    def insert_languages
      @languages.each do |language|
        sql = "INSERT INTO languages (language) VALUES (?)"
        @db.execute sql, [language]
      end
    end

    def insert_words
      @language_files.each do |language, file|
        File.readlines(file).each do |line|
          if /^(?<die_rolls>[123456]{5})\s+(?<words>.*)$/ =~ line
            sql = "INSERT INTO words " +
            "(language, die_rolls, words) VALUES (?, ?, ?)"
            @db.execute sql, [language, die_rolls, words]
          end
        end
      end
    end

    def create_language_die_rolls_index
      sql = "CREATE UNIQUE INDEX language_die_rolls " +
      "ON words (language, die_rolls)"
      @db.execute sql
    end
  end
end

if __FILE__ == $0
  database_file = "words.sqlite3"
  raw_data_dir = "database/raw_data"
  Passphrase::DatabaseHelper.list_languages(raw_data_dir)
  # db = DatabaseHelper.new("database_file, raw_data_dir)
  # db.drop_languages_table
  # db.drop_words_table
  # db.drop_language_die_rolls_index
  # db.create_languages_table
  # db.create_words_table
  # db.insert_languages
  # db.insert_words
  # db.create_language_die_rolls_index
end
