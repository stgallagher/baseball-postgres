class @GameEngine

  constructor: ->
    @inning = 1
    @side = "top"
    @score = 0
    @outs = 0
    @display = new Gameplay()
    @pitcher = new Pitching()
    @contact = new Contact()
    @baseRunners = new BaseRunners()
    @atBat = new AtBat(@pitcher, @contact, @baseRunners, @display)
    @initiateGame()

  initiateGame: ->
    @display.addGameReport("Play ball")
    @display.addGameReport("Inning #{@inning} - #{@side}")

  finishGame: ->
    return @display.gameFinished()

  makePitch: ->
    return @finishGame() if @gameFinished()
    @atBat = @nextBatter() if @atBat.complete
    @atBat.makePitch()
    @display.updateDisplay(@atBat)

  nextBatter: ->
    if @atBat.isOut
      nextBatter = @batterOut()
    else
      @batterHits()
      console.log("IN GAME ENGINE::nextBatter -> @atBat.baseOccupancy = #{JSON.stringify(@atBat.baseOccupancy)}")
      nextBatter = new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)
    @atBat = nextBatter

  batterOut: ->
    @outs += 1
    @display.updateOuts(@outs)
    if @outs is 3
      @retireSide()
      @display.clearAll()
      return new AtBat(@pitcher, @contact, @baseRunners, @display)
    else
      @display.updateDisplay(@atBat)
      return new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)

  batterHits: ->
    @score += @atBat.baseOccupancy.addedScore
    @display.updateDisplay(@atBat)

  retireSide: ->
    if @inning is 10 and @side is "top"
      return @finishGame()
    @display.updateScoreboard(@score, @inning, @side)
    if @side is "top"
      @side = "bottom"
      @display.addGameReport("Inning #{@inning} - #{@side}")
    else if @side is "bottom"
      @inning += 1
      @display.addGameReport("Inning #{@inning} - #{@side}")
    @score = 0
    @outs = 0

  gameFinished: ->
    @inning > 9
