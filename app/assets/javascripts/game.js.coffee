class @Game

  constructor: (homeId, awayId) ->
    @homeTeam = new Team()
    @awayTeam = new Team()
    @display  = new GameDisplay()
    pb = new Probabilities(3, 3, 3)
    @pitcher  = new Pitching(pb)
    @contact  = new Contact(pb)
    @baseRunners = new BaseRunners()
    @initializeHomeBattingOrder(1, 3)

  pitch: ->
    @gameEngine.makePitch()

  initializeHomeBattingOrder: (homeId, awayId) ->
    $.ajax
      dataType: 'json',
      type: 'GET',
      url: "http://localhost:4000/teams/#{homeId}",
      success : (data) =>
        console.log "DATA = #{JSON.stringify(data)}"
        @populateHomePlayers(data)
        @initializeAwayBattingOrder(awayId)

  initializeAwayBattingOrder: (awayId) ->
    $.ajax
      dataType: 'json',
      type: 'GET',
      url: "http://localhost:4000/teams/#{awayId}",
      success : (data) =>
        @populateAwayPlayers(data)
        @gameEngine  = new GameEngine(@homeTeam, @awayTeam, @display, @pitcher, @contact, @baseRunners)
        @display.battingOrder(@awayTeam.players, @homeTeam.players)
        @display.teamsPlaying(@awayTeam.name, @homeTeam.name)

  populateHomePlayers: (data) ->
    @homeTeam.players = _.map(_.pluck(data.players, "name"), (name) -> new Player(name))
    @homeTeam.name = data.name

  populateAwayPlayers: (data) ->
    @awayTeam.players = _.map(_.pluck(data.players, "name"), (name) -> new Player(name))
    @awayTeam.name = data.name
