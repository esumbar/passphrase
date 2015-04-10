module Passphrase
  # This is the main class of the Passphrase library for generating
  # passphrases. It's initialized with a two-element hash that specifies the
  # number of words in the resulting passphrase and a flag to use the
  # RANDOM.ORG site as a source of random numbers.
  # @example
  #   require "passphrase"
  #   p = Passphrase::Passphrase.new(number_of_words: 4, use_random_org: nil)
  #   puts p.generate
  class Passphrase

    # @return [String] the passphrase string
    attr_reader :passphrase

    # @return [Integer] the number of words in the passphrase
    attr_reader :number_of_words

    # @param options [Hash] characteristics for a new Passphrase object
    # @yieldparam obj [self] the Passphrase object
    def initialize(options={})
      @options = Default.options.merge(options)
      @number_of_words = @options[:number_of_words]
      @passphrase = ""
      @languages = []
      @die_rolls = []
      @words = []
      yield self if block_given?
    end

    # Invokes the Diceware method by running {DicewareMethod.run}. The three
    # resulting arrays are accumulated into instance variables. The words
    # array is formatted into a single passphrase string and stored in another
    # instance variable. The method returns itself to allow method chaining.
    # @return [self] a Passphrase object
    def generate
      @languages, @die_rolls, @words = DicewareMethod.run(@options)
      @passphrase = @words.join(" ")
      self
    end

    # A predicate method that returns true if the Passphrase object is
    # initialized to use RANDOM.ORG
    # @return [Boolean] returns true of RANDOM.ORG is being used
    def using_random_org?
      @options[:use_random_org]
    end

    # String representation of a Passphrase object
    # @return [String] the passphrase string
    def to_s
      @passphrase
    end

    # Returns details for the Passphrase object as a hash.
    # @return [Hash] the details of a Passphrase object
    def inspect
      {
        passphrase: @passphrase,
        number_of_words: @words.size,
        use_random_org: using_random_org?,
        word_origins: word_origins
      }
    end

    private

    def word_origins
      word_origins = {}
      @words.each_index do |index|
        word_origins[@words[index]] = {
          language: @languages[index],
          die_rolls: @die_rolls[index]
        }
      end
      word_origins
    end
  end
end
