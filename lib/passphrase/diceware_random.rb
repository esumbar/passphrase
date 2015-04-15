require "securerandom"
require "open-uri"

module Passphrase
  # The DicewareRandom class supplies random numbers in two different formats
  # through two instance methods {#indices} and {#die_rolls} for use by the
  # {DicewareMethod} class. Depending on the value of the flag used to
  # instantiate the DicewareRandom class, the unformatted raw random numbers
  # are generated either by the standard SecureRandom class or retrieved from
  # the RANDOM.ORG web site.
  class DicewareRandom
    class << self
      # @return [Integer] the number of times the RANDOM.ORG site is accessed
      #   by all instances of the DicewareRandom class
      attr_accessor :random_org_requests
    end

    @random_org_requests = 0

    # @param use_random_org [Boolean] a flag that triggers the use of
    #   RANDOM.ORG for generating random numbers
    def initialize(use_random_org)
      @random_org_uri = "https://www.random.org"
      use_random_org ? setup_remote_generator : setup_local_generator
    end

    # Returns an array of random numbers that can index into the array of
    # available languages. The number of elements in the array equals the
    # number of words specified for the passphrase.
    # @param number_of_words [Integer] the desired number of words in the
    #   passphrase
    # @param number_of_languages [Integer] the number of available languages
    # @return [Array<Integer>] an array of random number indices
    def indices(number_of_words, number_of_languages)
      generate_random_numbers(number_of_words, number_of_languages - 1)
    end

    # Returns an array of strings where each string comprises five numeric
    # characters, each one representing one roll of a die. The number of
    # elements in the array equals the number of words specified for the
    # passphrase.
    # @param number_of_words [Integer] the desired number of words in the
    #   passphrase
    # @return [Array<String>] an array of strings each one of which represents
    #   five rolls of a die
    def die_rolls(number_of_words)
      # The Diceware method specifies five rolls of the die for each word.
      die_rolls_per_word = 5
      total_die_rolls = number_of_words * die_rolls_per_word
      die_roll_sequence = generate_random_numbers(total_die_rolls, 6, 1)
      group_die_rolls(die_roll_sequence, number_of_words, die_rolls_per_word)
    end

    private
    
    def group_die_rolls(seq, number_of_words, die_rolls_per_word)
      die_rolls = []
      number_of_words.times do
        rolls_per_word = seq.shift(die_rolls_per_word)
        die_rolls << rolls_per_word.reduce("") { |roll, die| roll << die.to_s }
      end
      die_rolls
    end
    
    def setup_remote_generator
      self.class.class_eval do
        def generate_random_numbers(count, maximum, minimum=0)
          # Check quota before proceeding and thereafter every 1000 uses to
          # comply with random.org guidelines.
          check_random_org_quota if self.class.random_org_requests % 1000 == 0
          params = []
          params << "num=#{count}"
          params << "min=#{minimum}"
          params << "max=#{maximum}"
          params << "col=1"
          params << "base=10"
          params << "format=plain"
          params << "rnd=new"
          query  = "/integers/?#{params.join('&')}"
          array_of_random_numbers = []
          open("#{@random_org_uri}#{query}") do |data|
            data.each_line do |line|
              array_of_random_numbers << line.to_i
            end
          end
          self.class.random_org_requests += 1
          array_of_random_numbers
        end

        def check_random_org_quota
          query = "/quota/?format=plain"
          open("#{@random_org_uri}#{query}") do |data|
            quota = data.gets.chomp.to_i
            over_quota_message = "RANDOM.ORG over quota, try again in 10 minutes"
            raise "ERROR: #{over_quota_message}" if quota < 0
          end
        end

        private :generate_random_numbers
        private :check_random_org_quota
      end
    end
    
    def setup_local_generator
      self.class.class_eval do
        def generate_random_numbers(count, maximum, minimum=0)
          max = maximum - minimum + 1
          offset = minimum
          # array_of_random_numbers
          Array.new(count).map { |e| SecureRandom.random_number(max) + offset }
        end

        private :generate_random_numbers
      end
    end
  end
end
