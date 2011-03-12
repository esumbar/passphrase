#! /usr/bin/env ruby

module Passphrase
  module Version

    # rubygems rational versioning policy
    # http://docs.rubygems.org/read/chapter/7
    MAJOR = 0
    MINOR = 0
    BUILD = 3

    STRING = [MAJOR, MINOR, BUILD].compact.join('.')
  end
end
