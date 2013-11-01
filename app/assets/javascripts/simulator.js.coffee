class @Simulator

  constructor: (gameEngine) ->
    @game = gameEngine

  simulateGame: ->
    until @game.gameFinished()
      @game.makePitch()
