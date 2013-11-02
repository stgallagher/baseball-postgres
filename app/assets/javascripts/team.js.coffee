class @Team
  constructor: (name) ->
    @name = name
    @players = @createPlayers()
    @currentPlayerIndex = 0

  createPlayers: ->
    players = []
    _(9).times ->  players.push new Player()
    players

  firstBatter: ->
    @players[0]

  nextBatter: ->
    if @createPlayers
      if @currentPlayerIndex + 1 is @players.length
        @currentPlayerIndex = 0
        return @players[@currentPlayerIndex]
      else
        return @players[@currentPlayerIndex += 1]


