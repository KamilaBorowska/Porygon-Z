Request a puppy, get it. It's that simple.

    pug = ->
      request = require 'request'
      request 'http://pugme.herokuapp.com/random', (e, status, body) =>

The request return JSON. I've to parse it in order to get pug. I need
to remove `"` and everything after it, because for some reason
sometimes `pugme` service returns results like in
https://travis-ci.org/GlitchMr/PorygonZ/jobs/7685641 (thanks Travis,
for noticing that).

        @respond JSON.parse(body).pug.replace /".*/, ""

    pug.help = """
      Request a puppy, get it. It's that simple.
    """

    exports.pug = ->
      pug
