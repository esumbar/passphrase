#! /usr/bin/env ruby

require 'zlib'
require 'base64'
require File.join(File.dirname(__FILE__), 'data')

module Passphrase
  module WordList

    def self.create
      decoded_wordlists
    end

    private

    def self.decoded_wordlists
      Data::ENCODED.collect {|encoded_list| self.decode(encoded_list) }
    end

    def self.decode(encoded_list)
      decoded_list = {}
      lines = Zlib::Inflate.inflate(Base64.decode64(encoded_list)).split(/\n/)
      lines.grep(/^\d{5}/).each do |line|
        key, value = line.chomp.split
        decoded_list[key.to_sym] = value
      end
      decoded_list
    end
  end
end
