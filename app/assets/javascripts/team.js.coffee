$(document).ready ->

class @Team
  constructor: () ->
    @name = null
    @players = null
    @currentPlayerIndex = -1

  pitcher: ->
   _.detect(@players, (player) -> player.position is "P")

  nextBatter: ->
    if @currentPlayerIndex + 1 is @players.length
      @currentPlayerIndex = 0
      @players[@currentPlayerIndex]
    else
      @players[@currentPlayerIndex += 1]
