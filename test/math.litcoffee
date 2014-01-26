The test for math module. First, we have to import the math module.

    {math} = require '../plugins/math'

Also, we need mock function for testing fun stuff.

    {call} = require './meta/call'

Define every possible option.

    everything = hex: yes, binary: yes, octal: yes

Next, we can test basic stuff.

    describe 'Adding 2 to 2', ->
      it 'should work without options', ->
        call math(), '2 + 2', 'Result: 4'

      it 'should work with options', ->
        call math(everything), '2 + 2', 'Result: 4, 0x4, 0b100, 0o4'

    describe 'Variables', ->
      it 'should define a variable', ->
        call math(), 'i = 2 ^ 3', 'Result: 8'

      it 'should read it back', ->
        call math(), 'i', 'Result: 8'

Next, we test edge cases of Infinity.

    describe 'Infinity', ->
      it 'should give Infinity when the number is huge', ->
        call math(), '999 ** 999', 'Result: Infinity'

      it 'should give -Infinity when the number is very small', ->
        call math(), '-999 ** 999', 'Result: -Infinity'

      it "shouldn't output variations when number isn't finite", ->
        call math(everything), '-999 ** 999', 'Result: -Infinity'

Also, check whatever negative 0 works correctly.

    describe 'Negative 0', ->
      it 'should give 0 when 0 is positive', ->
        call math(), 'atan2(0, 0)', 'Result: 0'

      it 'should give pi when 0 is negative', ->
        call math(), 'atan2(0, -0)', "Result: #{Math.PI}"

      it 'should be able to return -0 as result', ->
        call math(everything), '-0', "Result: -0, -0x0, -0b0, -0o0"
