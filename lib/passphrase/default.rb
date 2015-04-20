module Passphrase
  # Class instance variables in this class define default values for
  # {Passphrase} options and the range for the number of words that can be
  # specified for a passphrase on the command-line.
  class Default
    class << self
      # @return [Hash] the default options used to instantiate a {Passphrase}
      #   object
      attr_reader :options
      # @return [Range] an arbitrary range specifying the allowable number of
      #   words in a passphrase, referenced by the {CLI.parse} method
      attr_reader :number_range
    end

    @options = {
      languages: ["all"],
      number_of_words: 5,
      passwordize: false,  # only relevant in {CLI.parse}
      use_random_org: false
    }
    @number_range = (3..10)
  end
end
