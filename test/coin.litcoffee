The test for randomness module that contains the coin.

    {coin} = require '../plugins/randomness'

Also, we need mock class for testing fun stuff.

    {call} = require './meta/call'

We need to check first whatever `help` can get list containing single
command.

    describe 'Coin', ->
      it 'should be random', (done) ->
        call coin(), "", (result) ->
          require('assert') result in ['Heads', 'Tails'], "It isn't a coin"
          done()
