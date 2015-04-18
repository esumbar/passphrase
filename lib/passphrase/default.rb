module Passphrase
  # Class instance variables in this class define default values for
  # {Passphrase} options and the range for the number of words that can be
  # specified for a passphrase on the command-line.
  class Default
    class << self
      # @return [Hash] the default options that the command line interface
      #   uses to instantiate a {Passphrase} object in {CLI.parse}
      attr_reader :options
      # @return [Range] an arbitrary range specifying the allowable number of
      #   words in a passphrase, referenced by the {CLI.parse} method
      attr_reader :number_range
    end

    @options = {
      languages: ["all"],
      number_of_words: 5,
      passwordize: nil,
      use_random_org: nil
    }
    @number_range = (3..10)
  end
end
