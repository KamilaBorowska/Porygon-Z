This function is responsible for calling plugin function, and using
callback when getting the result.

    exports.call = (plugin, argument, callback) ->
      if typeof callback isnt 'function'
        expectedResult = callback
        callback = (result) ->
          assert = require 'assert'
          assert.equal result, expectedResult

      plugin.call respond: callback, argument
