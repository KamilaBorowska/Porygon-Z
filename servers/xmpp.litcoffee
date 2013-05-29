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

The message might not have text (for example, presence messages).

          messageText = stanza.getChildText 'body'
          return unless messageText?

But if it does, process it.

          message = user: stanza.attrs.from, message: messageText
          @emit 'message', message

      pm: (messageText, person) ->
        message = to: person, type: 'chat'
        @client.send new Element('message', message).c('body').t messageText
