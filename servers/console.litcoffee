**console.litcoffee** is development console intended to help testing
PorygonZ.

    class exports.Console extends require('events').EventEmitter
      constructor: (@config) ->

I need to call constructor for `EventEmitter`.

        super()

Start REPL session with special eval.

      connect: ->
        require('repl').start
          eval: (message, context, filename, @callback) =>

The hack, because REPL expects JavaScript code.

            message = message.replace(/^\(/, "").replace /\n\)$/, ""

Send the message from REPL to parser.

            @emit 'message', user: 'REPL', message: message.replace /^\(|\n\)$/g, ""

Use callback to send the message back.

      pm: (message) ->
        @callback message
