#! /usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'options')
require File.join(File.dirname(__FILE__), 'wordlist')
require File.join(File.dirname(__FILE__), 'random')

module Passphrase
  class Generator

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
      number = numbers[Random.new(1, 0, numbers.length - 1).to_array.shift]
      @phrase[selected_index] = number
    end
    
    def mixin_nonalphanum
      non_alphanums = %w( ~ ! # $ % ^ & * \( \) - = + [ ] \\ { } : ; " ' < > ? / )
      # TODO
    end
    
    def selected_index
      index = Random.new(1, 0, @phrase.length - 1).to_array.shift
      word_breaks.include?(index) ? index.succ : index
    end
    
    def word_breaks
      @words[1..-2].inject([ @words.first.length ]) do |memo, word|
        memo << (memo.last + word.length.succ)
      end
    end
  end
end
