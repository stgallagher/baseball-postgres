class @Team
  constructor: (name) ->
    @name = name
    @players = @createPlayers()

  createPlayers: ->
    players = []
    _(9).times ->  players.push new Player()
    players

