**user.litcoffee** contains a `User` class intended to be used to
represent users.

    class exports.User
    
Specifies every `key` from `properties`.
    
      constructor: (properties) ->
        for property, value of properties
          @[property] = value

      toString: ->
        @nick
