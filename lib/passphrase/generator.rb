#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'options')
require File.join(File.dirname(__FILE__), 'wordlist')
require File.join(File.dirname(__FILE__), 'random')

module Passphrase
  class Generator

    NON_ALPHANUM_REGEX = /[~!#\$%\^&\*\(\)\-=\+\[\]\\\{\}:;"'<>\?\/]/
    NON_ALPHANUM_ARRAY = %w( ~ ! # $ % ^ & * \( \) - = + [ ] \\ { } : ; " ' < > ? / )
    
    attr_reader :phrase
    attr_reader :unmixed_phrase

    def initialize(argv)
      @options = Options.new(argv)
      @words = []
    end

    def run
      num_words = @options.num_words
      word_list = WordList.create
      list_selector = Random.new(num_words, 0, word_list.length - 1).to_array
      num_words.times do |iword|
        word_hash = Random.new(5, 1, 6).to_array.join.to_sym
        @words << word_list[list_selector[iword]][word_hash]
      end
      @unmixed_phrase = @words.join(" ")
      @phrase = @unmixed_phrase.clone
      mix_phrase if mix?
    end
    
    def mix?
      @options.mix
    end

    private

    def mix_phrase
      mixin_capital     unless @phrase =~ /[A-Z]/
      mixin_number      unless @phrase =~ /\d/
      mixin_nonalphanum unless @phrase =~ NON_ALPHANUM_REGEX
    end
    
    def mixin_capital
      index, character = make_character_selection
      @phrase[index] = character.upcase
    end
    
    def mixin_number
      index, character = make_character_selection
      numbers = ("0".."9").to_a
      number = numbers[one_random_number(numbers.length - 1)]
      @phrase[index] = number
    end
    
    def mixin_nonalphanum
      index, character = make_character_selection
      len = NON_ALPHANUM_ARRAY.length
      non_alphanum = NON_ALPHANUM_ARRAY[one_random_number(len - 1)]
      @phrase[index] = non_alphanum
    end
    
    def make_character_selection
      return [] unless @phrase =~ /[a-z]/
      index = one_random_number(@phrase.length - 1)
      character = @phrase.slice(index, 1)
      until character =~ /[a-z]/
        index = index.succ.modulo(@phrase.length)
        character = @phrase.slice(index, 1)
      end
      [index, character]
    end
    
    def one_random_number(max)
      Random.new(1, 0, max).to_array.shift
    end
  end
end
