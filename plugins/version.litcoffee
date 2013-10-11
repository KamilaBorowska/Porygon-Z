Plugin responsible for sending version of PorygonZ. ポリゴン is in Japanese.

    exports.version = ->
      self = ->
        @respond "ポリゴンZ version Z"

      self.help = """
        Shows ポリゴンZ version. Doesn't take arguments.
      """
      self
