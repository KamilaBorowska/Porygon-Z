Complex math evaluator. Uses `matheval` from npm to process equations.

    exports.math = ({hex, binary, octal}) ->
      self = (expr) ->
        {evaluate} = require 'matheval'

Evaluate may return SyntaxError.

        @respond try
          result = evaluate expr
          if result
            output = "Result: #{result}"
            if hex
              output += ", 0x#{result.toString(16).toUpperCase()}"
            if binary
              output += ", 0b#{result.toString 2}"
            if octal
              output += ", 0o#{result.toString 8}"

Return the final output.

            output

The math plugin could avoid outputing anything if the expression is
empty.

          else
            "No output"
        catch e
          "Error: #{e}"


      self.help = """
        Takes mathematical expression as argument and solves it.
      """
      self
