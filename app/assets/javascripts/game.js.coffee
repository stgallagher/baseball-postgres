class @Game

  constructor: (homeId, awayId) ->
    @homeTeam = new Team()
    @awayTeam = new Team()
    @display  = new GameDisplay()
    @pitcher  = new Pitching()
    @contact  = new Contact()
    @baseRunners = new BaseRunners()
    @prob = new Probabilities()
    @initializeHomeBattingOrder(1, 3)

  pitch: ->
    @gameEngine.makePitch()

  initializeHomeBattingOrder: (homeId, awayId) ->
    $.ajax
      dataType: 'json',
      type: 'GET',
      url: "http://localhost:4000/teams/#{homeId}",
      success : (data) =>
        @populateHomePlayers(data)
        @initializeAwayBattingOrder(awayId)

  initializeAwayBattingOrder: (awayId) ->
    $.ajax
      dataType: 'json',
      type: 'GET',
      url: "http://localhost:4000/teams/#{awayId}",
      success : (data) =>
        @populateAwayPlayers(data)
        @history = new GameHistory(@homeTeam, @awayTeam)
        @gameEngine  = new GameEngine(@homeTeam, @awayTeam, @display, @pitcher, @contact, @baseRunners, @prob, @history)
        @display.battingOrder(@awayTeam.players, @homeTeam.players)
        @display.pitchers(@awayTeam.pitcher(), @homeTeam.pitcher())
        @display.teamsPlaying(@awayTeam.name, @homeTeam.name)

  populateHomePlayers: (data) ->
    @homeTeam.players = _.map(data.players, (player) -> new Player(player.name, player.position, player.player_profile))
    @homeTeam.name = data.name

  populateAwayPlayers: (data) ->
    @awayTeam.players = _.map(data.players, (player) -> new Player(player.name, player.position, player.player_profile))
    @awayTeam.name = data.name
