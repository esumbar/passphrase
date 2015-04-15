require "digest/sha2"
require "passphrase/database_helper"

module Passphrase
  class RakeHelper
    include Rake::DSL

    attr_reader :gemspec

    def initialize
      gemspecs = Dir["*.gemspec"]
      raise "Found more than one gemspec file" unless gemspecs.size == 1
      gemspec_path = gemspecs.first
      @gemspec = Bundler.load_gemspec(gemspec_path)
    end

    def install_tasks
      desc "Calculate the checksum for #{gemspec.name}-#{gemspec.version}.gem"
      task :checksum do
        checksum_dir = "checksum"
        FileUtils.mkdir_p(checksum_dir)
        built_gem_path = "pkg/#{gemspec.name}-#{gemspec.version}.gem"
        checksums = {}
        checksums['256'] = Digest::SHA256.new.hexdigest(File.read(built_gem_path))
        checksums['512'] = Digest::SHA512.new.hexdigest(File.read(built_gem_path))
        checksums.each do |size, digest|
          path = "#{checksum_dir}/#{gemspec.name}-#{gemspec.version}.gem.sha#{size}"
          File.open(path, "w") { |f| f.write(digest) }
          puts "Checksum saved to #{path}."
        end
      end

      desc "Create and populate the wordlist database words.sqlite3"
      task :database do
        database_file = "words.sqlite3"
        raw_data_dir = "database/raw_data"
        wordlist_dir = "lib/passphrase/wordlist"
        FileUtils.rm(database_file, force: true)
        db = DatabaseHelper.new(database_file, raw_data_dir)
        puts "Created wordlist database file #{database_file}."
        puts "Wordlists in the following languages are available:"
        DatabaseHelper.list_languages(raw_data_dir)
        print "Please wait while these wordlists are added to the database... "
        show_wait_spinner { db.fresh_setup }
        FileUtils.mkdir_p(wordlist_dir)
        FileUtils.mv(database_file, wordlist_dir)
        puts "done."
      end
    end

    private

    def show_wait_spinner(fps=10)
      delay = 1.0/fps
      continue_spinning = true
      spinner = Thread.new do
        "|/-\\".chars.cycle do |c|
          print c
          sleep delay
          print "\b"
          break unless continue_spinning
        end
      end
    ensure
      yield.tap do
        continue_spinning = false
        spinner.join
      end
    end
  end
end

rake_helper = Passphrase::RakeHelper.new
rake_helper.install_tasks
