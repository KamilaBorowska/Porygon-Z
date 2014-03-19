The plugin that can be used for telling others stuff, when they are
away. Because it needs to have persistent state, it requires any sort
of database.

    tell = (message) ->

Load prepared schema from database.

      {TellMessage} = @database.models

If the message contains just command, it's just useless, because it
doesn't even mention the target.

      unless message
        @respond "You need to specify target and content"

I need to use external module in order to split, because otherwise
too much would be split. The split limits in JavaScript, while
existing, are completely broken, because they simple eat what you
don't need.

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

    tell.help = "Tells somebody about something. The first argument is" +
      " user name, second is what you want to say him."

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

Check if the message exists, and respond if it does. Because this remembers
the context, it's safe to use it in event.

      @database.models.TellMessage.findOne where: target: user, (err, message) =>
        return unless message?
        {user, target, content, date} = message
        @respond "<#{user}> #{target}, #{content}"

Remove the message if it wass mentioned.

        message.destroy()
