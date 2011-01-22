#! /usr/bin/env ruby

require 'net/http'
require 'securerandom'

module Passphrase
  class Random

    RANDOM_ORG = "www.random.org"

    attr_reader :num
    attr_reader :min
    attr_reader :max
    attr_reader :via_random_org
    attr_reader :rand_array

    def initialize(num, min, max)
      @num, @min, @max = num, min, max
      @rand_array = []
      generate_rand_array
    end

    private

    def generate_rand_array
      query = "/integers/?col=1&base=10&format=plain&rnd=new" + 
        "&num=#{@num}&min=#{@min}&max=#{@max}"
      site = Net::HTTP.new(RANDOM_ORG)
      response, data = site.get(query)
      raise unless response.code == "200"
      @rand_array = data.split.collect {|num| num.to_i}
      @via_random_org = true
    rescue
      max = @max - @min + 1
      offset = @min
      @num.times do
        @rand_array << (SecureRandom.random_number(max) + offset)
      end
      @via_random_org = false
    end
  end
end
