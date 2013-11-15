$(document).ready ->

class @Team
  constructor: () ->
    @name = null
    @players = null
    @currentPlayerIndex = 0

  firstBatter: ->
    @players[0]

  pitcher: ->
   _.detect(@players, (player) -> player.position is "P")

  nextBatter: ->
    if @currentPlayerIndex + 1 is @players.length
      @currentPlayerIndex = 0
      return @players[@currentPlayerIndex]
    else
      return @players[@currentPlayerIndex += 1]
