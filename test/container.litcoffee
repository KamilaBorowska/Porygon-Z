The test for containers. First, we have to import the container.

    {Container} = require '../container'

    {equal} = require 'assert'

The fake class to help testing container.

    class Server extends require('events').EventEmitter
      connect: ->
        @callback()

      pm: (message, user) ->
        if message is '42' and user is 'me'
          @callback()
        else
          throw new Error 'Invalid PM'

Next, we must make an instance of container for testing.

    container = new Container
      plugins:
        test: (arg) ->
          @respond arg
      server: server = new Server

Connect the server using Container.

    describe 'Container', ->
      it 'should connect', (done) ->

Define a callback for server.

        server.callback = done

Connect to server, so callback would be called.

        container.connect()

After connecting, it should be able to send messages.

      it 'should send messages', (done) ->
        server.callback = done
        container.pm('42', 'me')

And receive them.

      it 'should receive messages', (done) ->
        server.callback = done

Emit event that container should catch.

        server.emit 'message', message: 'test 42', user: 'me'

Check whatever commands are commands.

      it 'should know its commands', ->
        for command of container.getCommands()
          equal command, 'test'
