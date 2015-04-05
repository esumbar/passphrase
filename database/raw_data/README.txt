The files here are for use in generating multi-lingual diceware-like passphrases.

Diceware was initially described and developed by Arnold G. Reinhold at

 http://world.std.com/~reinhold/diceware.html

I, Jeffrey Goldberg, have described for a more general audience here:

  http://blog.agilebits.com/2011/06/21/toward-better-master-passwords/

The files

Afrikaans-dice.txt
Croatian-dice.txt
Czech-dice.txt
English-dice.txt
Finnish-dice.txt
French-dice.txt
Hungarian-dice.txt
Italian-dice.txt
Japanese-dice.txt
Latin-dice.txt
Norwegian-dice.txt
Polish-dice.txt
Spanish-dice.txt
Swahili-dice.txt
Swedish-dice.txt
Turkish-dice.txt

are derived from the word lists created by Solar Designer of the Openwall Project

  http://www.openwall.com/wordlists/

The lists here are lowercase words using only the ascii set [a-z] between 4 and 8
characters long. Duplicates have been removed so that, for example, a word like
"foto" will appear on at most one of these lists.

Unlike the original diceware list these lists have more than 7776 items (with
the exception of Hungarian and Swahili, cutting off at 8 characters eliminated
too many words), so set of five roles of a die may correspond to more than one
word.

INTENTION

The original diceware system is ideal for generating strong, memorable
passphrases. But the passphrases it generates can be long and difficult to
type on the keyboards of small portable devices like phones. For example, the
original diceware list includes things with digits as well as letters.

The idea here is to expand list of words, using lists from several
languages, so that the passphrase may be shorter at the expense of
a slightly more complicated generation process and having to learn
(and memorize) a few words in a language that you may not be familiar
with.

The overview is that this works like diceware, but first you select which
language to use for your first word, get the word in the normal diceware way;
select a language for the second word, select via diceware from that word
list, and so on.

STRENGTH

If you pick from these 16 languages at random for each word then a three word
multi-language diceware passphrase is only one bit weaker (50.7 bits) than a
four word traditional diceware passphrase (51.7). A four word multi-language
passphrase will a few bits stronger than a five word traditional one (67 vs 65
bits). A two word multi-language diceware password, at 33 bits, remains too weak.


INSTRUCTIONS:

First decide how many words long you would like your passphrase to be. Suppose
you pick 4.

Then select (ideally at random) a language to use for the first word. 

Selecting a language at random

Divide the 16 languages into two groups, say alphabetically, putting
everything from Afrikaans to Italian in the first group and Japanese
through Turkish in the second group.

Flip a coin. If it comes up heads, select the first group. If it
comes up tails, select second group.

Now split your selected group in half, flip a coin to select which
half to go with.  Repeat this until you have one language remaining.

Roll five dice (or one die five times) keeping track of the numbers.
The order matters. That five roles getting you 4-6-5-1-5 is distinct
from five roles producing 6-4-5-1-5.

Look for the line beginning with 46515. This will get you a line in
French-dice.txt that looks like:

  46515 boxais devorez glanant optez shabitua

providing five words you may choose from. Pick whichever one strikes your
fancy. (I like shabitua, whatever that means.)

That will then be the first word of your passphrase.

Now repeat the process for the remaining words. Select a language, role five
dice, pick a word from the corresponding line.

Important note: If you don't any of the words available for a particular role,
you may role the dice again, but then you MUST role all five dice again. Do
NOT go hunting around the file to find a word you like. You may reject a role,
but whatever word you do select it must be something that corresponds to a
random roll of the dice.

To get the most benefit from using multiple langauges you should select your
language at random (possibly rolling dice as part of that process).
