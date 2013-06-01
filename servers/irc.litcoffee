**irc.litcoffee** contains the `IRC` class. It's responsible for
connecting to IRC, and reacting for events.

    class exports.IRC extends require('events').EventEmitter
      constructor: (@config) ->

I need to call constructor for `EventEmitter`.

        super()

      connect: ->

Use `irc` module instead of reimplementing everything myself, like I
did in YIBot.

        {Client} = require 'irc'
        @client = new Client null, null, @config

        @client.on 'message', (nick, target, message, {user, host}) =>
          {User} = require '../user'
          user = new User {nick, user, host}
          if target is @client.nick
            @emit 'message', {user, message}
          else
            @emit 'channel', {user, message, channel: target}

        if @config.nickServPassword
          @client.on 'motd', =>
            message = "identify #{@config.nickServPassword}"
            @pm message, @config.nickServUsername or 'NickServ'

      say: (message, channel) ->
        @client.say channel, message

      pm: ->
        @say arguments...
