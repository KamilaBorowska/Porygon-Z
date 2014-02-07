The test for randomness module that contains the coin.

    {coin} = require '../plugins/randomness'

Also, we need mock class for testing fun stuff.

    {call} = require './meta/call'

We need to check first whatever `help` can get list containing single
command.

    describe 'Coin', ->
      it 'should be random', (done) ->
        call coin(), "", (result) ->

The test can generate either "Heads" or "Tails", depending on
randomness. Both options are allowed to happen, so we have to allow
both.

          require('assert') result in ['Heads', 'Tails'], "Check if it is a coin"
          done()
