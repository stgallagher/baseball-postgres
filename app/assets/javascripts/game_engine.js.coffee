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
    @display.addGameReport("Play ball", true)
    @display.addGameReport("<b>Inning #{@inning} - #{@side}</b><br><b>-----------------</b>", true)

  finishGame: ->
    return @display.gameFinished()

  makePitch: ->
    return @finishGame() if @gameFinished()
    @atBat = @nextBatter() if @atBat.complete
    @atBat.makePitch()
    @display.updateDisplay(@atBat)

  nextBatter: ->
    console.log("IN GAME ENGINE::nextBatter -> @atBat = #{JSON.stringify(@atBat)}")
    console.log("IN GAME ENGINE::nextBatter -> @atBat.isOut = #{@atBat.isOut}")
    if @atBat.isOut
      nextBatter = @batterOut()
    else
      @batterHits()
      #console.log("IN GAME ENGINE::nextBatter -> @atBat.baseOccupancy = #{JSON.stringify(@atBat.baseOccupancy)}")
      nextBatter = new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)
    @display.clearBatter()
    @display.addGameReport("NextBatter<br>-----------", true)
    @atBat = nextBatter

  batterOut: ->
    @outs += 1
    console.log("IN GAME ENGINE::batterOut -> @outs = #{@outs}")
    @display.updateOuts()
    if @outs is 3
      @retireSide()
      @display.clearAll()
      return new AtBat(@pitcher, @contact, @baseRunners, @display)
    else
      #@display.updateDisplay(@atBat)
      return new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)

  batterHits: ->
    @score += @atBat.baseOccupancy.addedScore
    #@display.updateDisplay(@atBat)

  retireSide: ->
    if @inning is 10 and @side is "top"
      return @finishGame()
    @display.updateScoreboard(@score, @inning, @side)
    if @side is "top"
      @side = "bottom"
      @display.addGameReport("<b>Inning #{@inning} - #{@side}</b><br><b>-----------------</b>", true)
    else if @side is "bottom"
      @inning += 1
      @side = "top"
      @display.addGameReport("<b>Inning #{@inning} - #{@side}</b><br><b>-----------------</b>", true)
    @score = 0
    @outs = 0

  gameFinished: ->
    @inning > 9
