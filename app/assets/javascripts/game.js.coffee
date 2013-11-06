class @Game

  constructor: (homeTeam, awayTeam) ->
    @homeTeam = homeTeam
    @awayTeam = awayTeam
    @display  = new GameDisplay()
    @pitcher  = new Pitching()
    @contact  = new Contact()
    @baseRunners = new BaseRunners()
    @gameEngine  = new GameEngine(@homeTeam, @awayTeam, @display, @pitcher, @contact, @baseRunners)

  pitch: ->
    @gameEngine.makePitch()

  initializeBattingOrder: ->
    awayBattingLineup = _.map([1..9], (num) -> $("#gamedisplay-away-batter-#{num}-name"))
    _.each(@awayTeam.players, (value, key, list) -> awayBattingLineup[key].text(value.name))

    homeBattingLineup = _.map([1..9], (num) -> $("#gamedisplay-home-batter-#{num}-name"))
    _.each(@homeTeam.players, (value, key, list) -> homeBattingLineup[key].text(value.name))
