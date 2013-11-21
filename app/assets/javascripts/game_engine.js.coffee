class @GameEngine

  constructor: (@homeTeam, @awayTeam, @display, @pitching, @contact, @baseRunners, @prob) ->
    @inning = 1
    @side = "Top"
    @score = 0
    @outs = 0
    @atBat = null
    @gameInitiated = false
    @gameOver = false
    @batter = null
    @pitcher = null
    @homeFirstBatterNotUpYet = true
    @display.game = this
    @display.startGame()
    @nextAtBat()
    @display.nextBatter()


  finishGame: ->
    @gameOver = true
    @display.gameFinished()

  makePitch: ->
    unless @gameOver
      if @atBat.complete
        @nextBatter()
        @display.nextBatter()
      @atBat.makePitch()
      @display.updateDisplay(@atBat)
      @display.updateScoreboard(@score, @inning, @side)

  nextBatter: ->
    if @atBat.isOut
      @batterOut()
    else
      @batterHits()
      @nextAtBat()
    @display.clearBatter()
    #unless @gameFinished()
    #  @display.nextBatter()

  batterOut: ->
    @outs += 1
    @display.updateOuts()
    if @outs is 3
      @retireSide()
      @display.clearAll()
      @nextAtBat()
    else
      @nextAtBat()

  batterHits: ->
    @score += @atBat.baseOccupancy.addedScore

  retireSide: ->
    if @inning is 9 and @side is "Bottom"
      return @finishGame()
    if @side is "Top"
      @side = "Bottom"
      @display.inning()
    else if @side is "Bottom"
      @inning += 1
      @side = "Top"
      @display.inning()
    @atBat.clearBases()
    @score = 0
    @outs = 0

  gameFinished: ->
    @inning is 9 and @side is "Bottom" and @outs is 3

# private
  nextAtBat: ->
    @determineAtBatProbabilities(@playersAtBat())
    baseOccupancy = @atBat.baseOccupancy if @atBat
    @atBat = new AtBat(@pitching, @contact, @baseRunners, @display, baseOccupancy, @prob)

  playersAtBat: ->
    if @side is "Top"
      @pitcher = @homeTeam.pitcher()
      @batter = @awayTeam.nextBatter()
    else if @side is "Bottom"
      @pitcher = @awayTeam.pitcher()
      @batter = @homeTeam.nextBatter()

  determineAtBatProbabilities: ->
    @prob.newProbabilities(@batter.profile.batting_power, @batter.profile.batting_contact, @pitcher.profile.pitching)
    @pitching.newPitcher(@prob)
    @contact.newBatter(@prob)
