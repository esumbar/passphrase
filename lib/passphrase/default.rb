module Passphrase
  class Default
    class << self
      # @return [Hash] the default options that the command line interface
      #   uses to instantiate a {Passphrase} object in {CLI.parse}
      attr_reader :options
      # @return [Range] an arbitrary range specifying the allowable number of
      #   words in a passphrase, referenced by the {CLI.parse} method
      attr_reader :number_range
    end

    @options = { number_of_words: 5, passwordize: nil, use_random_org: nil }
    @number_range = (2..10)
  end
end
