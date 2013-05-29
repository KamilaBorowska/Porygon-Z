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

        @client.on 'stanza', (stanza) =>

The message might not have text (for example, presence messages). If
then, just echo it, so it would appear that PorygonZ listens to you (by
fake typing, for example), but bot should never respond to errors.

          messageText = stanza.getChildText 'body'

          if messageText?
            message = user: stanza.attrs.from, message: messageText
            @emit 'message', message
          else if stanza.is('message') and stanza.attrs.type isnt 'error'
            stanza.attrs.to = stanza.attrs.from
            delete stanza.attrs.from

I'm evil echo server, and I reply to you with your status.

            @client.send stanza

      pm: (messageText, person) ->
        message = to: person, type: 'chat'
        @client.send new Element('message', message).c('body').t messageText
