# Change Log
All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning](http://semver.org/).

## Version 1.1.0 - 2015-04-xx
### Added
- Added SHA256 checksum calculation to rake_helper.rb.
- Added `:use_random_org` key to Passphrase#inspect.
- Added `--passwordize|-p` option to convert a passphrase into a password.

### Changed
- Made `number_of_words` an attribute of the Passphrase class.
- Generate a passphrase when a Passphrase object is instantiated.
- The passphrase attribute is now an instance of PassphraseString which
  encapsulates the `#to_password` method.

## Version 1.0.0 - 2015-04-06
This release is a complete re-write. None of the code from the previous
release was retained.

### Added
- Added YARD-style documentation throughout.
- Added an RSpec test suite using the newer syntax that comes with
  version ~> 3.0.
- Added option `--use-random|-r` for specifying RANDOM.ORG as a source of
  random numbers.
- The gem is cryptographically signed.

### Changed
- Absolutely everything!
- Changed the default source for random numbers from the RANDOM.ORG web site
  to the SecureRandom standard library.
- Diceware method selects words from 15 multi-lingual wordlists.
- Wordlists are stored in an SQLite 3 database file.
- Code organized to conform to current RubyGems guidelines.
- Re-designed the library to make it easier to use in client code.

### Removed
- Removed option `--mix|-m` for mixing in a capital letter, number, and a
  special character.
- Removed option `--local|-l` to force the use of the SecureRandom standard
  library to generate random numbers.
- Replaced the hash used to store the wordlists with an external SQLite 3
  database file.

## Version 0.1.0 - 2011-04-25
No change log was maintained for this and prior versions.
