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
    
    def mixin_capital
      return unless @phrase =~ /[a-z]/
      index = selected_index
      character = @phrase.slice(index, 1)
      until character =~ /[a-z]/
        index = index.succ.modulo(@phrase.length)
        character = @phrase.slice(index, 1)
      end
      @phrase[index] = character.upcase
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
