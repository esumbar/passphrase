#! /usr/bin/env ruby

require 'optparse'
require File.join(File.dirname(__FILE__), 'version')

module Passphrase
  class Options

    NUM_WORDS_RANGE = (3..10)
    DEFAULT_NUM_WORDS = 5

    attr_reader :num_words
    attr_reader :mix

    def initialize(argv)
      @num_words = DEFAULT_NUM_WORDS
      @mix = true
      parse(argv)
      validate
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: passphrase [options]"
        opts.separator "Options:"
        opts.on("-n", "--num-words NUMBER", Integer,
                "Desired number of words (#{NUM_WORDS_RANGE.to_s}), default #{DEFAULT_NUM_WORDS}") do |num|
          @num_words = num
        end
        opts.on("-x", "--[no-]mix", "Mix in odd character, default mix") do |m|
          @mix = m
        end
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        opts.on_tail("-v", "--version", "Show version") do
          puts "#{File.basename($PROGRAM_NAME)}, version #{Passphrase::Version::STRING}"
          exit
        end

        begin
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(1)
        end
      end
    end

    def validate
      unless NUM_WORDS_RANGE.include?(@num_words)
        STDERR.puts "Number of words out of range: allowed #{NUM_WORDS_RANGE.to_s}: specified #{@num_words}"
        exit(1)
      end
    end
  end
end
