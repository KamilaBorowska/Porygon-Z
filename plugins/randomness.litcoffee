The plugin is about all things random.

This function implements coin throw using Random.org. It doesn't have
any configuration.

    exports.coin = ->
      self = ->
        {integers} = require 'node-random'

`node-random` requires callback. This implements the callback. Because
`this` always knows where the message was done, even when the time
passed (because of fake object with prototype), it's always safe.

        integers maximum: 1, (error, data) =>
          if error
            @respond "Error: #{error}"
            return

`node-random` returns array of numbers.  Because of that, I've to 
access first element.

          @respond if data[0] then "Heads" else "Tails"

      self.help = """
        Throws a coin using random.org for added randomness.
      """
      self
