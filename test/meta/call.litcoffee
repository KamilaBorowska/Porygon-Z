This function is responsible for calling plugin function, and using
callback when getting the result.

    exports.call = (plugin, argument, callback, extraOptions = {}) ->
      {extend} = require 'underscore'
      assert = require 'assert'

The callback can be a function (that will be called and is expected to
call `assert`), a regular expression (it checks whatever it matches it,
or a string (checks whatever it's equal).

      expectedResult = callback

If it's RegExp, check whatever it matches.

      if callback instanceof RegExp
        callback = (result) ->
          {inspect} = require 'util'
          error = "#{expectedResult} doesn't match #{inspect result}"
          assert.ok expectedResult.test(result), error

If it isn't RegExp, check whatever it is equal.

      else if typeof callback isnt 'function'
        callback = (result) ->
          assert.equal result, expectedResult

      plugin.call extend(extraOptions, respond: callback), argument
