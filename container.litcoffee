**container.litcoffee** contains the `Container` class. The container
is responsible for processing messages, and starting actual server.

Load Underscore.js. Some code here requires it (nothing too important,
but sometimes helpful).

    _ = require "underscore"

Define actual, exported class.

    class exports.Container

Constructor sets `@config` to its first argument, and sets the server
container to this container.

      constructor: (@config) ->
        @config.server.container = this

Prepare storages prior to their use.

        @storage = {}
        @channelStorage = {}
        @messageStorage = {}

        @databaseConnect()

Convert prefix to RegExp with the anchor at beginning.

        prefix = @config.prefix ? ""

        @config.prefix = new RegExp(
          "^(?:#{prefix.source ? prefix})(?=\\w)",
          if prefix.ignoreCase then "i",
        )

Connect to the database specified in config if it exists. Otherwise,
code that actually uses `@config.database` will fail, so you will know
it won't work.

      databaseConnect: ->
        if @config.database
          {Schema} = require 'jugglingdb'
          @database = new Schema @config.database.driver, @config.database
          @defineSchemas()

Load every schema, and implement them in `@database.models`.

      defineSchemas: ->
        for plugin in @getAllPlugins()
          for schemaName, schema of plugin.schemas
            @database.define schemaName, schema

        @database.isActual (err, actual) =>
          @database.autoupdate()

The `connect` method connects to server and starts listening.

      connect: ->
        @config.server.connect()
        
Start listening for messages and channels.

        for type in ['message', 'channel']
          do (type) =>
            @config.server.on type, (event) =>
              @parseEvent type, event
        return

`say` method can be used to say something on channel.

      say: (message, channel) ->
        @config.server.say message, channel

`pm`  method can be used to say something to somebody. Generally, it's
very similar to `say`, except that some protocols may have differences
between people and channels.

      pm: (message, person) ->
        @config.server.pm message, person

Parses event and redirects it to plugins.

      parseEvent: (type, event) ->

Abuse prototype inheritance in order to have container object with
magical automatically removed properties.

        container = Object.create this

Gets commands for current type of message.

        container.response = event

`respond` method is responsible for responding to the person who
triggered the message. `type` may only contain `channel` or `message`.

        container.respond = (message) ->
          if @response.channel
            @say message, @response.channel
          else
            @pm message, @response.user

When event parsers are defined, call them.

        for eventParser in @config.eventParsers or []
          eventParser.call container, type, event

Remove prefix at beginning of line. Leave function quickly if `type` is
`'say'`, and the prefix wasn't removed.

        removed = no

        message = event.message.replace @config.prefix, ->
          removed = yes
          ""

        return if type is 'channel' and not removed

Generate storage if it doesn't exist.

        container.storage = @config[type + "Storage"]?[event.target] ?= {}

Split the command in two parts using `strsplit`.

        [name, message] = require('strsplit') message, /\s+/, 2

Get the plugin for the command.

        plugin = @config[type + "Plugins"]?[name] or @config.plugins[name]

If plugin exists, call it.

        if plugin
          plugin.call container, message

Otherwise, use command not found handler, if it does exist.

        else
          @config.commandNotFound?.call container, name, message


Gets list of commands for channel or person. If the `channel` argument
isn't specified, it's assumed to be current channel, or nothing if this
is private message.

      getCommands: (channel = @response?.channel) ->

Return combination of channel commands and general commands. The
channel list is second because it overwrites entries in generic
plugins.

        _.extend @config.plugins, @config.channelPlugins?[channel] ? {}

Gets all plugins. This is rather hacky, but does what you would expect.

      getAllPlugins: ->
        _.values(@config.plugins).concat _.values(@config.plugins).map _.values
