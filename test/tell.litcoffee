The test for help module. First, we have to import the tell module.

    {tell, tellCheck} = require '../plugins/tell'

And call its methods.

    tell = tell()
    tellCheck = tellCheck()

Also, we need mock class for testing fun stuff.

    {call} = require './meta/call'

And assertions.

    assert = require 'assert'

Initialize memory database.

    {Schema} = require 'jugglingdb'
    database = new Schema 'memory'
    TellMessage = database.define 'TellMessage', tell.schemas.TellMessage

    describe 'Tell command', ->
      it 'should claim to save', (done) ->
        call tell, 'i am good', (result) ->
          assert.equal result, "I will tell i about this.", "Got result message"
          done()
        , {response: user: 'me', database}

      it 'should actually save', (done) ->
        result = TellMessage.all {
          where:
            user: 'me'
            target: 'i'
            content: 'am good'
        }, (err, result) ->
          assert.equal result.length, 1, "It wasn't saved"
          done()
