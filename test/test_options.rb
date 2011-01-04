#! /usr/bin/env ruby

require 'test/unit'
require 'options'

class TestOptions < Test::Unit::TestCase

  def test_000_empty_args
    opts = Passphrase::Options.new([])
    assert_equal Passphrase::Options::DEFAULT_NUM_WORDS, opts.num_words
    assert opts.mix
  end

  def test_001_specify_num_words
    num = Passphrase::Options::DEFAULT_NUM_WORDS - 1
    opts = Passphrase::Options.new(%W{--num-words #{num}})
    assert_equal num, opts.num_words
    assert opts.mix
  end

  def test_002_specify_mix
    opts = Passphrase::Options.new(%W{--no-mix})
    assert_equal Passphrase::Options::DEFAULT_NUM_WORDS, opts.num_words
    assert !opts.mix
  end

  def test_003_specify_num_words_and_mix
    num = Passphrase::Options::DEFAULT_NUM_WORDS - 1
    opts = Passphrase::Options.new(%W{--num-words #{num} --no-mix})
    assert_equal num, opts.num_words
    assert !opts.mix
  end
end
