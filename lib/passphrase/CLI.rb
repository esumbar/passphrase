require "optparse"

module Passphrase
  # The CLI class encapsulates a simple command line interface to the
  # {Passphrase} library. The class method {parse} merges any given command
  # line arguments with a hash of default options. The resulting hash is then
  # used to instantiate a Passphrase object and generate one passphrase, which
  # is printed on standard output.
  # @example
  #   require "passphrase"
  #   Passphrase::CLI.parse(ARGV)
  class CLI
    # @param args [Array<String>] array of command line elements, typically
    #   given by ARGV (may be empty)
    # @return [void]
    def self.parse(args)
      # Gotcha:
      # The contents of an instance variable can be changed outside the class
      # through a reader attribute. For example,
      #   class A
      #     attr_reader :x
      #     def initialize
      #       @x = { a: 1, b: 2 }
      #     end
      #   end
      #   a = A.new
      #   p a.x        #=> {:a=>1, :b=>2}
      #   x = a.x
      #   x[:b] = 99
      #   p a.x        #=> {:a=>1, :b=>99}
      # Therefore, need to clone the default hash otherwise parsing could
      # alter the hash's contents. Although this causes no harm in the
      # command-line tool, it causes havoc in the test suite.
      options = Default.options.clone

      default_number_of_words = Default.options[:number_of_words]
      default_random_org = Default.options[:use_random_org] ? "--random-org" : "--no-random-org"
      default_number_range = Default.number_range

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: passphrase [options]"
        opts.on(:REQUIRED, "-n NUM", "--num-words=NUM", Integer,
          "Number of words in passphrase #{default_number_range}",
          "(default: #{default_number_of_words})") do |n|
            options[:number_of_words] = n
          end
        opts.on(:NONE, "-p", "--[no-]passwordize",
          "Add one cap, one num, and one special char",
          "(default: TBD)") do |p|
            options[:passwordize] = p
        end
        opts.on(:NONE, "-r", "--[no-]random-org",
          "Use RANDOM.ORG to generate random numbers",
          "(default: #{default_random_org})") do |r|
            options[:use_random_org] = r
        end
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit(0)
        end
        opts.on_tail("-v", "--version", "Show version") do
          puts VERSION
          exit(0)
        end
      end

      begin
        parser.parse!(args)
        validate_number_of_words(options)
        puts Passphrase.new(options)
      rescue OptionParser::InvalidOption => e
        handle_error(e)
      rescue OptionParser::MissingArgument => e
        handle_error(e)
      # gracefully handle exit(0) from --help and --version options
      rescue SystemExit => e
        exit(e.status)
      rescue Exception => e
        handle_error(e)
      end
    end

    def self.validate_number_of_words(options)
      number_of_words = options[:number_of_words]
      unless Default.number_range.include?(number_of_words)
        raise "number of words out of range #{Default.number_range}"
      end
    end

    def self.handle_error(error)
      STDERR.puts "ERROR: #{error.message}"
      exit(1)
    end

    class << self
      private :validate_number_of_words, :handle_error
    end
  end
end
