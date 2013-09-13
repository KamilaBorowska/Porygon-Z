The plugin that can be used for telling others stuff, when they are
away. Because it needs to have persistent state, it requires any sort
of database.

    tell = (message) ->

Load prepared schema from database.

      {TellMessage} = @database.models

      unless message
        @respond "You need to specify target and content"

      [target, content] = require('strsplit') message, /\s+/, 2

If there is no content specified, automatically write something.

      content or= "You know what I mean."

      TellMessage.findOne where: {user: @response.user, target}, (err, message) =>

The message could either exist or not. If it exists, then modify its
instance, instead of creating new message.

        message or= new TellMessage
        message.user = @response.user
        message.target = target
        message.content = content
        message.save()

        @respond "I will tell #{target} about this."

    tell.help = """
      Tells somebody about something. The first argument is user name,
      second is what you want to say him.
    """

Define schemas for initial processing.

    tell.schemas =
      TellMessage:
        user:
          type: String
          index: yes
        target:
          type: String
          index: yes
        content:
          type: String
        date:
          type: Date
          default: Date.now

    exports.tell = ->
      tell

    exports.tellCheck = -> (type, {user}) ->
      return unless user? and type in ['message', 'channel', 'join']
      @database.models.TellMessage.findOne where: target: user, (err, message) =>
        return unless message?
        {user, target, content, date} = message
        @respond "<#{user}> #{target}, #{content}"
        message.destroy()
