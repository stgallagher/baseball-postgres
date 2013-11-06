class @Game

  constructor: (homeTeam, awayTeam) ->
    @homeTeam = homeTeam
    @awayTeam = awayTeam
    @devHomeTeam = @homeTeam.getTeamInfo()
    @display  = new GameDisplay()
    @pitcher  = new Pitching()
    @contact  = new Contact()
    @baseRunners = new BaseRunners()
    @gameEngine  = new GameEngine(@homeTeam, @awayTeam, @display, @pitcher, @contact, @baseRunners)
    @initializeBattingOrder()

  pitch: ->
    @gameEngine.makePitch()

  initializeBattingOrder: ->
    @display.battingOrder(@awayTeam.players, @homeTeam.players)
    console.log "IN GAME::initializeBattingOrder -> @homeTeam.players = #{JSON.stringify(@homeTeam.players)}, @devHomeTeam.players = #{JSON.stringify(@devHomeTeam)}"
