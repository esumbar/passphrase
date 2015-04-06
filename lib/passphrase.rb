module Passphrase; end

Passphrase.autoload(:CLI, "passphrase/CLI")

mandatory_modules = [
  "default",
  "diceware_method",
  "diceware_random",
  "language_query",
  "passphrase",
  "version",
  "word_query"
]
mandatory_modules.each do |mod|
  require "passphrase/#{mod}"
end
