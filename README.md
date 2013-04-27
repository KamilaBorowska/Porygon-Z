PorygonZ
========

[![Build Status](https://travis-ci.org/GlitchMr/PorygonZ.png?branch=master)](https://travis-ci.org/GlitchMr/PorygonZ)

The simple IRC bot that sort of works. It contains an IRC server
support, but can be used without IRC (as REPL). It's very configurable
by using plugins, and you can even decide whatever command name is used
by the plugin.

## Plugins available

* `randomness`
  * `coin` - throws a coin, while using random.org
* `help`
  * `help` - allows you to read list of commands, and help for the
    command. You can overwrite the help, by changing the `help`
    property of the object.
* `math`
  * `math` - uses `matheval` to solve mathematical problem. Takes three
    configuration arguments, `hex`, `binary`, and `octal`. Those decide
    whatever the calculator shows the results in other bases.
* `version`
  * `version` - shows pointless version information. Yep.

## Installation

The first step would be to clone the repository, but I assume you know
how to do this ☺. I mean, it isn't that hard. Next, you have to
download dependencies using `npm install`.

You will need to write some code to load plugins of IRC bot, and its
servers. The source code already contains one, available in the
[`porygonz.litcoffee.sample`](porygonz.litcoffee.sample) file. You're
encouraged to copy it to `porygonz.litcoffee` file, so CoffeeScript
could load it. The `sample` is just here, so you could easily
pull from git repository, even if you have changed the configuration.
It's recommended to not change sample, unless you want to have problems
with pulling in future.

Because the configuration file is written in CoffeeScript, you should
be aware that it cares about indentation. It's also sort of complex,
but it also gives lots of flexibility. If you feel like, you can even
monkey punch things while using CoffeeScript syntax. You generally
shouldn't have to, but sometimes it's needed. Generally, the
configuration file has two things you would have to change.

### Plugins

The first would be list of plugins, and the second would be
the list of containers. By default, PorygonZ contains list of plugins
containing one plugin.

    {version} = require './plugins/version'

    plugins =
      version: version()

This imports the plugin file `./plugins/version`, and imports the
function from it called `version`. Every plugin is a function you
should call to get the function. The reason why you have to call it,
is that the plugin can be configured. `version` doesn't have any sort
of configuration, but some plugins, like `math` can have it.

The `plugins` array contains the list of commands and the plugins
mapped to it. If you would like that `version` be called like `ver`,
you could add `ver: version()`.

### Servers

The second would be list of servers. By default, this bot joins
`#botters-test` on Freenode, and enabled REPL. Adding the new servers
would be simply adding new entries that follow the pattern. The list
of the channels is array, separated by commas.

The prefix is regular expression. It has to be at beginning of the
message, otherwise bot won't listen. It uses the regular expressions
syntax. To learn more about them, check out [regular-expressions.info]
(http://www.regular-expressions.info/). It contains a short tutorial
for regular expressions.

If you still cannot survive regular expressions, you can put string
here. It's less flexible, but it works. Mostly.

## Running

    node_modules/coffee-script/bin/coffee porygonz.litcoffee

Alternatively, if you have installed `coffee-script` globally, you can
simply use it without specifying full path to `coffee`.

If you want a server for running PorygonZ, you could be interested
with [heroku](https://www.heroku.com/). This IRC bot already contains
`Procfile` that contains Heroku specific configuration. Only one worker
dyno is needed (and it should be enough, this bot really doesn't
require lots of CPU power, unlike certain other programs), and Heroku
offers one free dyno per app.
