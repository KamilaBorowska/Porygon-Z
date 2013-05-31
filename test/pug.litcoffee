Let's check whatever pug pugs.

    pug = require('../plugins/pug').pug()

Also, we need mock class for testing fun stuff.

    {call} = require './meta/call'

    describe 'Pug command', ->
      it 'should pug with the image', ->
        call pug, "", /^https?:.*\.(jpg|jpeg|gif|png|bmp)$/
