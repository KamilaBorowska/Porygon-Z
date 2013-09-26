Typical command found handler. That one shows similar command when in
can. Can be slightly slow when you have lots of commands, but generally
it should respond quickly.

Uses levenshtein module to determine whatever the command is similar or
not. Might not be accurate in certain cases. Improvements welcome.

    exports.commandNotFound = ->
      (userCommand) ->
        Levenshtein = require 'levenshtein'
        _ = require 'underscore.string'

List commands with distance of 2 or lower.

        commands = (
          command for command of @getCommands() \
          when new Levenshtein(command, userCommand).distance <= 2
        )

`commands.sort()` has side effects.

        commands.sort()

When the list isn't empty, return possible commands.

        if commands.length
          words = _.toSentence commands, ", ", " or "
          @respond "Did you mean #{words}?"
        else
          @respond "Command not found"
