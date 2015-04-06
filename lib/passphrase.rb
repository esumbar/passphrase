require "passphrase/default"
require "passphrase/diceware_method"
require "passphrase/diceware_random"
require "passphrase/language_query"
require "passphrase/passphrase"
require "passphrase/version"
require "passphrase/word_query"

module Passphrase
  autoload(:CLI, "passphrase/CLI")
end
