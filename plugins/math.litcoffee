Complex math evaluator. Uses `matheval` from npm to process equations.

    exports.math = ({hex, binary, octal} = {}) ->
      self = (expr) ->
        {evaluate} = require 'matheval'

Evaluate may throw SyntaxError.

        @respond try
          result = evaluate expr
          if result?

Checks whatever number is negative, including negative zero. I can
recognize negative and positive zero by dividing by it. Positive will
give positive infinity, negative will give negative infinity.

            minus = result > 0 or result is 0 and 1 / result is Infinity
            minusSign = if minus then "" else "-"
            result = Math.abs result

            output = "Result: #{minusSign}#{result}"

The infinite result shouldn't be converted to other bases.

            if isFinite result
              if hex
                output += ", #{minusSign}0x#{result.toString(16).toUpperCase()}"
              if binary
                output += ", #{minusSign}0b#{result.toString 2}"
              if octal
                output += ", #{minusSign}0o#{result.toString 8}"

Return the final output.

            output

The math plugin could avoid outputing anything if the expression is
empty.

          else
            "No output"
        catch e

Errors reported by `matheval` should be `SyntaxError`.

          if e instanceof SyntaxError
            "Error: #{e.message}"

If they are anything else, something is really wrong, and should be
rethrown, just to inform the user about the bug.

          else
            throw e


      self.help = """
        Takes mathematical expression as argument and solves it.
      """
      self
