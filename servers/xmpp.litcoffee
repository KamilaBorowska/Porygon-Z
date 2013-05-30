**xmpp.litcoffee** contains the `XMPP` class. It's responsible for
connecting to XMPP, and reacting for events.

    {Client, Element} = require 'node-xmpp'

    class exports.XMPP extends require('events').EventEmitter
      constructor: (@config) ->

I need to call constructor for `EventEmitter`.

        super()

      connect: ->

        @client = new Client @config

The bot should mark itself as online.

        @client.on 'online', =>
          @client.send new Element('presence', {}).c('show').t('chat').up()

Join every conference on the list of conferences, provided that list of
conferences was specified in the configuration.

          @conferences = {}
          for conference in @config.conferences or []
            @conferences[conference] = true
            @client.send new Element 'presence', to: conference

        @client.on 'stanza', (stanza) =>

          console.log require('util').inspect stanza, depth: null

          {type, from} = stanza.attrs

The message might not have text (for example, presence messages). If
then, just echo it, so it would appear that PorygonZ listens to you (by
fake typing, for example), but bot should never respond to errors.

          messageText = stanza.getChildText 'body'

          if messageText?
            message = user: from, message: messageText
            if type is 'groupchat'

Ignore messages sent from yourself, because they most likely would
cause infinite loops. Also, ignore answering messages from backlog,
because they are most likely old.

              return if @conferences[from] or stanza.getChild 'delay'

              message.channel = from.substring 0, from.indexOf '/'
              @emit 'channel', message
            else
              @emit 'message', message
          else if stanza.is('message') and type isnt 'error'
            stanza.attrs.to = from
            delete stanza.attrs.from

I'm evil echo server, and I reply to you with your status.

            @client.send stanza

Define `pm` and `say` in terms of `genericSend` method.

      pm: (messageText, person) ->
        @genericSend messageText, person, 'chat'

      say: (messageText, channel) ->
        @genericSend messageText, channel, 'groupchat'

      genericSend: (messageText, target, what) ->
        properties = to: target, type: what
        @client.send new Element('message', properties).c('body').t messageText
