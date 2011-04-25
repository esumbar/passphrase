#! /usr/bin/env ruby

module Passphrase
  module Version

    # rubygems rational versioning policy
    # http://docs.rubygems.org/read/chapter/7
    MAJOR = 0
    MINOR = 1
    BUILD = 0

    STRING = [MAJOR, MINOR, BUILD].compact.join('.')
  end
end
