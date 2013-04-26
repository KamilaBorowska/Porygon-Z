Plugin responsible for getting help.

    exports.help = ->
      self = (command) ->

If the command wasn't found, help user by showing every command in the
bot. The list is sorted because objects don't guarantee any sort of
order.

        if not command
          @respond "Commands: #{Object.keys(@getCommands()).sort().join ", "}"
          return

        @respond @config.plugins[command]?.help or 'Help page not found.'

      self.help = """
        Shows help for a plugin. Takes one argument that is name of the command.
      """
      self
