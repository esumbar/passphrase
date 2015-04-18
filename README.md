# Passphrase
Use Passphrase to generate a passphrase for SSH or GPG keys. For example, on
the command-line, run

    $ passphrase --num-words=4
    dokusi uolgo allunga totalisa

or programmatically,

~~~ruby
require "passphrase"
p = Passphrase::Passphrase.new(number_of_words: 4)
passphrase = p.passphrase
~~~

Passphrase also has the capability to generate passwords (indirectly).

## Installation
The Passphrase command-line tool and library can be installed with

    $ gem install passphrase

However, because the gem is cryptographically signed to prevent tampering, the
preferred installation command should include the `--trust-policy` security
option, which causes the gem to be verified before being installed. To invoke
this option, you must first add my public key `esumbar.pem` to your list of
trusted certificates, as follows.

    $ gem cert --add <(curl -Ls https://raw.githubusercontent.com/esumbar/passphrase/master/certs/esumbar.pem)

Finally, specify the appropriate security level when installing.

    $ gem install passphrase --trust-policy MediumSecurity

Using `MediumSecurity` rather than `HighSecurity` omits dependent gems that
are not signed from the verification process. Passphrase depends on the
unsigned gem `sqlite3`.

## Basic usage
### Command-line tool

    $ passphrase --help
    Usage: passphrase [options]
        -l, --languages=LANG1,...    Specify languages to use, none for a listing
                                     (default: --languages=all)
        -n, --num-words=NUM          Number of words in passphrase 3..10
                                     (default: --num-words=5)
        -p, --[no-]passwordize       Add one cap, one num, and one special char
                                     (default: --no-passwordize)
        -r, --[no-]random-org        Use RANDOM.ORG to generate random numbers
                                     (default: --no-random-org)
        -h, --help                   Show this message
        -v, --version                Show version

    $ # generate a passphrase using default settings
    $ passphrase
    sinmak termyne ismus affidavo recur

    $ # generate a four-word passphrase
    $ passphrase -n4
    apaisado vermouth seemag ebelik

    $ # generate a passphrase using only English and Spanish words
    $ passphrase --languages=english,spanish
    fumada hearsay murcio phosphor azufroso

    $ # generate a three-word Polish passphrase and password
    $ passphrase -lp -n3 -p
    podejrza zmalala wypadkow
    8odej=za_Xmalala_wypadkow

    $ # list the available languages
    $ passphrase -l
    afrikaans
    croatian
    czech
    diceware
    english
    ...

### Ruby library
Initialize a Passphrase object with

~~~ruby
Passphrase::Passphrase.new(options={})
~~~

The following options are accepted.

* `:languages` - array of languages from which to select words
  (default: `["all"]`)
* `:number_of_words` - number of words to select (default: `5`)
* `:use_random_org` - source random numbers from RANDOM.ORG (default: `false`)

For example,

~~~ruby
require "passphrase"

# generate a passphrase with default options
p = Passphrase::Passphrase.new
puts "passphrase: #{p}"
puts "passphrase internals: #{p.inspect}"

# generate three four-word passphrases using RANDOM.ORG
options = { number_of_words: 4, use_random_org: true }
p = Passphrase::Passphrase.new(options)
passphrase1 = p.generate.passphrase
passphrase2 = p.generate.passphrase
passphrase3 = p.generate.passphrase

# generate an array of six-word passphrases
passphrase_array = Array.new(100)
Passphrase::Passphrase.new(number_of_words: 6) do |p|
  passphrase_array.map! { |array_element| p.generate.passphrase }
end

# generate a passphrase using only French and Italian words
options = { number_of_words: 4, languages: %w( fr italian ) }
p = Passphrase::Passphrase.new(options)
passphrase = p.passphrase

# generate a password from a passphrase
p = Passphrase::Passphrase.new(number_of_words: 3)
passphrase = p.passphrase
password   = passphrase.to_password
~~~

## Background
### Diceware Method
Passphrase implements the [Diceware
Method](http://world.std.com/~reinhold/diceware.html) which constructs a
passphrase by randomly selecting words from a predefined list of more-or-less
meaningful words. Because the words are meaningful, the resulting passphrase
is easier to remember and type. And because the selection is random, it is
more secure. The more words in a passphrase, the better. However, four or five
is optimal.

The original Diceware wordlist from 1995 contained only English words. Since
then, [Diceware-compatible wordlists in other
languages](https://blog.agilebits.com/2013/04/16/1password-hashcat-strong-master-passwords/expanded-dicelists/) have been published and are incorporated
into Passphrase. Unfortunately, the enhanced security of the result comes at
the expense of having to deal with words from potentially unfamiliar languages.
_Note that these are not merely translations of the original Diceware
wordlist._

Passphrase includes wordlists in the following 15 languages (stored in an
SQLite 3 database file).

1. Afrikaans
2. Croatian
3. Czech
4. Diceware (the original Diceware wordlist)
5. English
6. Finnish
7. French
8. Italian
9. Japanese
10. Latin
11. Norwegian
12. Polish
13. Spanish
14. Swedish
15. Turkish

Except in the original Diceware list, all words are lower case, comprised of
characters from the ascii set `[a-z]`. The original Diceware list includes
some "words" with numerical and punctuation characters. To the best of my
knowledge, no word appears more than once in this set of wordlists.

The _dice_ in Diceware refers to the act of rolling a die to achieve
randomness. A sequence of five consecutive rolls has 7776 (or 6<sup>5</sup>)
possible outcomes. Each combination maps to one line in a given wordlist, and
each line, in turn, is composed of between 1 and 15 words (depending on the
language, the average being 5).

Therefore, to select a word, Passphrase

1. randomly selects one of 15 languages
2. randomly selects one of 7776 lines from the corresponding wordlist
3. randomly selects one word from the corresponding line

This leads to roughly 2<sup>66</sup> (or 10<sup>28</sup>) possible five-word
passphrases, for example.

Passphrase simulates the rolls of a die by using random numbers from one of
two sources. The default is to use the standard SecureRandom class. You also
have the option of requesting random numbers from
[RANDOM.ORG](http://www.random.org). However, because RANDOM.ORG depends on
network access, it is susceptible to network problems, and is also slower.

### Subset of languages
By default, Passphrase randomly selects words from the collection of available
languages. If desired, the selection can be limited to a subset. This can be
done on the command-line and in code by supplying a list of language names or
abbreviations. An abbreviation comprises the first one or two letters of a
language name, just enough to avoid ambiguity.

### Passwords
A typical passphrase will not satisfy password policies that require the use
of upper case letters, numbers, and special characters (~, !, and the like).
Therefore, Passphrase gives you the option to replace three randomly selected
characters in a generated passphrase with one random upper case letter
`[A-Z]`, one random integer `[0-9]`, and one random special character. Spaces
are not usually allowed either, so they are replaced with underscores as part
of this process.

## Contributing to Passphrase
After forking the [repository on
GitHub](https://github.com/esumbar/passphrase), go to your local copy of the
repository  and execute `bundle install` to ensure that all development gems
are installed.

Then, run `rake database` to create and populate the wordlist database. Note
that even though raw data files for Hungarian and Swahili exist, these
languages are excluded from the database because they do not have a full
compliment of 7776 entries.

To run the command-line tool within the repository directory, try `ruby -Ilib
bin/passphrase`. You can also experiment with the library in irb. For example,

    $ irb -Ilib -rpassphrase
    >> p = Passphrase::Passphrase.new(number_of_words: 3)
    => {:passphrase=>"jazzy vannier viscount", :number_of_words=>3, ... }
    >> p.passphrase
    => "jazzy vannier viscount"
    >> p.passphrase.to_password
    => "jazz{_2annier_vBscount"
    >> p = Passphrase::Passphrase.new(languages: ["e", "fr"])
    => {:passphrase=>"obstrua lamparos orgy forerez deduce", ... }

Run the tests with `rake spec`.

## Changelog
See {file:CHANGELOG.md} for a list of changes.

## License
Passphrase &copy; 2011-2015 by [Edmund Sumbar](mailto:esumbar@gmail.com).
Passphrase is licensed under the MIT license. Please see the {file:LICENSE}
document for more information.
