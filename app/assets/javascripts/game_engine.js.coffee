class @GameEngine

  constructor: (display) ->
    @inning = 1
    @side = "top"
    @score = 0
    @outs = 0
    @display = display
    @pitcher = new Pitching()
    @contact = new Contact()
    @baseRunners = new BaseRunners()
    @atBat = new AtBat(@pitcher, @contact, @baseRunners)

  finishGame: ->
    return display.gameFinished()

  makePitch: ->
    return @finishGame() if @gameFinished()
    @atBat = @nextBatter() if @atBat.complete
    @atBat.makePitch()
    @display.updateDisplay(@atBat)

  nextBatter: ->
    if @atBat.isOut
      @batterOut()
    else
      @batterHits()
    return new AtBat(@pitcher, @contact, @baseRunners, @atBat.baseOccupancy)

  batterOut: ->
    @outs += 1
    @retireSide() if @outs is 3
    @display.updateDisplay(@atBat)

  batterHits: ->
    @score += @atBat.baseOccupancy.addedScore
    @display.updateDisplay(@atBat)

  retireSide: ->
    if @inning is 9 and @side is "top"
      return @finishGame()
    @display.updateDisplay(score, @inning, @side)
    if @side is "top"
      @side = "bottom"
    else if @side is "bottom"
      @inning += 1
    @score = 0
    @outs = 0

  gameFinished: ->
    @inning > 9
