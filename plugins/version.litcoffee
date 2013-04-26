Plugin responsible for sending version of PorygonZ.

    exports.version = ->
      self = ->
        @respond "ポリゴンZ version Z"

      self.help = """
        Shows ポリゴンZ version. Doesn't take arguments.
      """
      self
