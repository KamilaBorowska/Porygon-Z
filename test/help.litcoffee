The test for help module. First, we have to import the help module.

    help = require('../plugins/help').help()

Also, we need mock class for testing fun stuff.

    {call} = require './meta/call'

We need to check first whatever `help` can get list containing single
command.

    describe 'Help command', ->
      it 'should be able to list itself', ->
        call help, '', 'Commands: help', getCommands: -> {help}
      it 'should be able to show the help for itself', ->
        call help, 'help', help.help, getCommands: -> {help}
