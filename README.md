Pattern Expander
======

## Installation

Add this line to your application's Gemfile:

    gem 'pattern_expander'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pattern_expander

Usage
=====

Takes patterns and outputs their combinations - think reverse regex. Lazily loads "pages" of combinations and returns results before the heat death of the universe.

Pass in a string with randomly chosen values in square brackets"[]":

    expander = PatternExpander.new(
      "My [startup|band|puppy's] name is [i|e||Power |Awesome ][Ninja|Rockstar] [Ministry|Labs|Quux]"
    )

Get random samples with #sample:

    expander.sample # my startup name is Power Rockstar Ministry
    expander.sample # my puppy's name is iNinja Labs
    expander.sample(3) # get multiple samples

Get specific index values:

    expander = PatternExpander.new("[a|b][1|2]")
    expander[0] # "a1"
    expander[1] # "a2"
    expander[0..3] # ["a1", "a2", "b1", "b2"]

By default you can use "+d" and "+w" to map to digits and alphanumeric
characters. Here's an example of constructing a big UUID like pattern:

    expander = PatternExpander.new(
      "[+w][+w][+w][+w]-[+w][+w][+w][+w]-[+w][+w][+w][+w]-[+w][+w][+w][+w]"
    )
    expander.sample # "eo6a-68m6-coxw-14j7"
    expander[10_000_000_000..10_000_000_002]
    # returns ["aaaa-aaaa-aaaa-ahz2", "aaaa-aaaa-aaaa-ahz3", "aaaa-aaaa-aaaa-ahz4"]

And you can pass your own substitutes in and come up with your next
startup elevator pitch:

    expander = PatternExpander.new("It's like [+company] for [+customer]",
      substitutes: {
       '+company' =>  ['Chat Roulette',  'Kickstarter', 'Stack Overflow', 'SpaceX'],
       '+customer' => ['Texas', 'pets', 'tweens', 'magicians', 'figure skaters']
      }
    )
    expander.sample # It's like Chat Roulette for magicians
    expander.sample # It's like Stack Overflow for Texas
    expander.sample # It's like SpaceX for figure skaters


TODO
====
* Sample should return any value only once
* Error when max range has been exceeded for the index
* Delegate methods from PatternExpander to CombinationIndex
* API for adding substitutes
* PatternExpander#all(max:n)
* Filters (e.g. matches pattern, not in exclusion set, max length)
* Ranges for filtered results


Contributing
=====

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
