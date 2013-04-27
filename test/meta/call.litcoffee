This function is responsible for calling plugin function, and using
callback when getting the result.

    exports.call = (plugin, argument, callback, extraOptions) ->
      {extend} = require 'underscore'

The callback is allowed to not be a function. In this case, it's
assumed to be simple `assert.equal` test.

      if typeof callback isnt 'function'
        expectedResult = callback
        callback = (result) ->
          assert = require 'assert'
          assert.equal result, expectedResult

      plugin.call extend(extraOptions, respond: callback), argument
