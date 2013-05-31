Request a puppy, get it. It's that simple.

    pug = ->
      request = require 'request'
      request 'http://pugme.herokuapp.com/random', (e, status, body) =>

The request return JSON. I've to parse it in order to get pug.

        @respond JSON.parse(body).pug

    pug.help = """
      Request a puppy, get it. It's that simple.
    """

    exports.pug = ->
      pug
