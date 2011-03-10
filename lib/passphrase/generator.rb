#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'options')
require File.join(File.dirname(__FILE__), 'wordlist')
require File.join(File.dirname(__FILE__), 'random')

module Passphrase
  class Generator

    attr_reader :phrase
    attr_reader :unmixed_phrase
    attr_reader :words

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
      @phrase = @unmixed_phrase = @words.join(" ")
      mix_phrase if mix?
    end
    
    def mix?
      @options.mix
    end

    private

    def mix_phrase
      @nchars = @phrase.length
      mixin_capital
      mixin_number
      mixin_nonalphanum
    end
    
    def xxx
      odd_char_index = Random.new(1, 0, odd.length - 1).to_array.shift
      word_index = Random.new(1, 0, @num_words - 1).to_array.shift
      word_length = @words[word_index].length
      char_index = Random.new(1, 0, word_length - 1).to_array.shift unless word_length.zero?
      char_index ||= 0
      @words[word_index][char_index] = @odd_char = odd[odd_char_index]
      @phrase = @words.join(' ')
    end
    
    def mixin_capital
      # TODO
    end
    
    def mixin_number
      numbers = ("0".."9").to_a
      # TODO
    end
    
    def mixin_nonalphanum
      non_alphanums = %w( ~ ! # $ % ^ & * \( \) - = + [ ] \\ { } : ; " ' < > ? / )
      # TODO
    end
  end
end
