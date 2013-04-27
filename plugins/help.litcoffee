Plugin responsible for getting help.

    exports.help = ->
      self = (command) ->

If the command wasn't found, help user by showing every command in the
bot. The list is sorted because objects don't guarantee any sort of
order.

        if not command
          {toSentence} = require 'underscore.string'
          @respond "Commands: #{toSentence Object.keys(@getCommands()).sort()}"
          return

        @respond @getCommands()[command]?.help or 'Help page not found.'

      self.help = """
        Shows help for a plugin. Takes one argument that is name of the command.
      """
      self
