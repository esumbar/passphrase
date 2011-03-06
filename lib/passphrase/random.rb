#! /usr/bin/env ruby

require 'net/http'
require 'securerandom'

module Passphrase
  class Random

    def initialize(num, min, max)
      @num, @min, @max = num, min, max
      @array_of_rands = []
      generate_array_of_rands
    end
    
    def via_random_org?
      @via_random_org
    end
    
    def to_array
      @array_of_rands
    end

    private

    def generate_array_of_rands
      query = "/integers/?col=1&base=10&format=plain&rnd=new" + 
        "&num=#{@num}&min=#{@min}&max=#{@max}"
      site = Net::HTTP.new("www.random.org")
      response, data = site.get(query)
      raise unless response.code == "200"
      @array_of_rands = data.split.collect {|num| num.to_i}
      @via_random_org = true
    rescue
      max = @max - @min + 1
      offset = @min
      @num.times do
        @array_of_rands << (SecureRandom.random_number(max) + offset)
      end
      @via_random_org = false
    end
  end
end
