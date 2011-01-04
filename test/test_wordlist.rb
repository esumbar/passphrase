#! /usr/bin/env ruby

require 'test/unit'
require 'wordlist'

class TestOptions < Test::Unit::TestCase

  def setup
    @wordlist = Passphrase::WordList.create
  end

  def test_000_sample_words
    assert_equal 2, @wordlist.length
    assert_equal "embalm", @wordlist[0][:'24356']
    assert_equal "potato", @wordlist[1][:'46132']
  end
end
