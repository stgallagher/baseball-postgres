class @Game

  constructor: (homeTeam, awayTeam) ->
    @homeTeam = homeTeam
    @awayTeam = awayTeam
    @display  = new GameDisplay()
    @pitcher  = new Pitching()
    @contact  = new Contact()
    @baseRunners = new BaseRunners()
    @gameEngine  = new GameEngine(@homeTeam, @awayTeam, @display, @pitcher, @contact, @baseRunners)
    @initializeBattingOrder()

  pitch: ->
    @gameEngine.makePitch()

  initializeBattingOrder: ->
    @display.battingOrder(@awayTeam.getTeamInfo(1), @homeTeam.getTeamInfo(3))
