#! /usr/bin/env ruby

require 'net/http'
require 'securerandom'

module Passphrase
  class Random

    @@use_random_org = true

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
    
    def self.use_local
      @@use_random_org = false
    end  

    private

    def generate_array_of_rands
      if @@use_random_org
        query = "/integers/?col=1&base=10&format=plain&rnd=new" + 
          "&num=#{@num}&min=#{@min}&max=#{@max}"
        site = Net::HTTP.new("www.random.org")
        response, data = site.get(query)
        raise unless response.code == "200"
        @array_of_rands = data.split.collect {|num| num.to_i}
        @via_random_org = true
      else
        local_rands
        @via_random_org = false
      end
    rescue
      local_rands
      @via_random_org = false
    end

    def local_rands
      max = @max - @min + 1
      offset = @min
      @num.times do
        @array_of_rands << (SecureRandom.random_number(max) + offset)
      end
    end
  end
end
