module Passphrase
  # This subclass of String implements the {#passwordize} instance method for
  # substituting a capital letter, number, and special character into a
  # passphrase. Note that although #passwordize can be called on a
  # PassphraseString object any number of times, the result will not change
  # after the first call.
  class PassphraseString < String
    # @param passphrase [String] the passphrase as an ordinary String object
    # @param use_random_org [Boolean] a flag that triggers the use of
    #   RANDOM.ORG for generating random numbers
    def initialize(passphrase, use_random_org)
      super(passphrase)
      @use_random_org = use_random_org
      @random = DicewareRandom.new(use_random_org)
    end
    
    # @return [PassphraseString] a new PassphraseString that has been
    #   passwordized
    def passwordize
      @scratch = self.clone
      capital_index, number_index, special_index = @random.indices(3, @scratch.length)
      substitute_capital_letter(capital_index)
      substitute_number(number_index)
      substitute_special_character(special_index)
      @scratch
    end

    private

    def substitute_capital_letter(random_index)
      # Just in case the passphrase already includes a capital letter.
      return if /[A-Z]/ =~ @scratch
      capital_letter = ("A".."Z").to_a.sample
      substitute(capital_letter, random_index)
    end

    def substitute_number(random_index)
      # The Diceware wordlist includes "words" that include numbers.
      return if /[0-9]/ =~ @scratch
      number = ("0".."9").to_a.sample
      substitute(number, random_index)
    end

    def substitute_special_character(random_index)
      # The Diceware wordlist includes "words" that include special characters.
      return if /[~!#\$%\^&\*\(\)\-=\+\[\]\\\{\}:;"'<>\?\/]/ =~ @scratch
      special_character = %w( ~ ! # $ % ^ & * \( \) - = + [ ] \\ { } : ; " ' < > ? / ).sample
      substitute(special_character, random_index)
    end

    def substitute(substitution, random_index)
      character = @scratch[random_index]
      @scratch[random_index] = substitution and return if /[a-z]/ =~ character
      next_index = random_index.succ.modulo(@scratch.length)
      until next_index == random_index
        character = @scratch[next_index]
        @scratch[next_index] = substitution and return if /[a-z]/ =~ character
        next_index = next_index.succ.modulo(@scratch.length)
      end
    end
  end
end
