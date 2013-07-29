**console.litcoffee** is development console intended to help testing
PorygonZ.

    class exports.Console extends require('events').EventEmitter
      constructor: (@config) ->

I need to call constructor for `EventEmitter`.

        super()

Start REPL session with special eval.

      connect: ->
        repl = require('repl').start
          eval: (message, context, filename, @callback) =>

I remove parens, because REPL expects JavaScript code, as it was
intended to be used with JavaScript code. As I still have JavaScript
mode enabled (because I want tab completion), I have to remove this
hack from result.

            message = message.replace(/^\(/, "").replace /\n\)$/, ""

Send the message from REPL to parser.

            @emit 'message', user: 'REPL', message: message.replace /^\(|\n\)$/g, ""

Monkey patch repl in order to have proper tab completion.

        repl.complete = (line, callback) =>

If the command has spaces, don't tab complete.

          if line.indexOf(' ') >= 0
            callback null, [[], ""]
            return

Filter only commands that begin with actually inserted line.

          commands = Object.keys(@container.getCommands()).filter (command) =>
            line is command.substr 0, line.length

Use callback to return results to REPL itself.

          callback null, [commands, line]

Use callback to send the message back.

      pm: (message) ->
        @callback message
