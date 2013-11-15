class @GameEngine

  constructor: (@homeTeam, @awayTeam, @display, @pitcher, @contact, @baseRunners) ->
    @inning = 1
    @side = "Top"
    @score = 0
    @outs = 0
    @atBat = null
    @initiateGame()
    @gameInitiated = false
    @gameOver = false
    @batter = null
    @homeFirstBatterNotUpYet = true

  initiateGame: ->
    @display.addGameReport("Play ball", "heading")

  finishGame: ->
    @gameOver = true
    return @display.gameFinished()

  makePitch: ->
    unless @gameInitiated
      @display.addGameReport("Inning #{@inning} - #{@side}", "outline")
      @display.addGameReport("First Batter", "nextBatter")
      @pitcher.newPitcher(@awayTeam.pitcher())
      @contact.newBatter(@awayTeam.firstBatter())
      @atBat = new AtBat(@pitcher, @contact, @baseRunners, @display)
      @display.addGameReport(@awayTeam.firstBatter().name, "nextBatter")
      @gameInitiated = true
    unless @gameOver
      @atBat.makePitch()
      @display.updateDisplay(@atBat)
      @atBat = @nextBatter() if @atBat.complete
      @display.updateScoreboard(@score, @inning, @side)

  nextBatter: ->
    if @atBat.isOut
      nextBatter = @batterOut()
    else
      @batterHits()
      if @side is "Top"
        @pitcher.newPitcher(@awayTeam.pitcher())
        @contact.newBatter(@awayTeam.nextBatter())
        nextBatter = new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)
      else if @side is "Bottom"
        @batter = @homeTeam.nextBatter()
        @pitcher.newPitcher(@homeTeam.pitcher())
        @contact.newBatter(@homeTeam.nextBatter())
        nextBatter = new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)
    @display.clearBatter()
    unless @gameFinished()
      @display.addGameReport("Next Batter", "nextBatter")
    if @side is "Top"
      @batter = @awayTeam.nextBatter()
      @display.addGameReport(@batter.name, "nextBatter")
    else if @homeFirstBatterNotUpYet
      @batter = @homeTeam.firstBatter()
      @display.addGameReport(@batter.name, "nextBatter")
      @homeFirstBatterNotUpYet = false
    else if @side is "Bottom"
      @batter = @homeTeam.nextBatter()
      @display.addGameReport(@batter.name, "nextBatter")
    console.log "IN GAME_ENGINE::nextBatter -> nextBatter = #{JSON.stringify(nextBatter)}"
    @atBat = nextBatter


  batterOut: ->
    @outs += 1
    @display.updateOuts()
    if @outs is 3
      @retireSide()
      @display.clearAll()
      if @side is "Top"
        @pitcher.newPitcher(@awayTeam.pitcher())
        @contact.newBatter(@awayTeam.nextBatter())
        return new AtBat(@pitcher, @contact, @baseRunners, @display)
      else if @side is "Bottom"
        @pitcher.newPitcher(@homeTeam.pitcher())
        @contact.newBatter(@homeTeam.nextBatter())
        return new AtBat(@pitcher, @contact, @baseRunners, @display)
    else
      if @side is "Top"
        @pitcher.newPitcher(@awayTeam.pitcher())
        @contact.newBatter(@awayTeam.nextBatter())
        return new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)
      else if @side is "Bottom"
        @pitcher.newPitcher(@homeTeam.pitcher())
        @contact.newBatter(@homeTeam.nextBatter())
        return new AtBat(@pitcher, @contact, @baseRunners, @display, @atBat.baseOccupancy)

  batterHits: ->
    @score += @atBat.baseOccupancy.addedScore

  retireSide: ->
    if @inning is 9 and @side is "Bottom"
      return @finishGame()
    if @side is "Top"
      @side = "Bottom"
      @display.addGameReport("Inning #{@inning} - #{@side}<br>", "outline")
    else if @side is "Bottom"
      @inning += 1
      @side = "Top"
      @display.addGameReport("Inning #{@inning} - #{@side}<br>", "outline")
    @score = 0
    @outs = 0

  gameFinished: ->
    @inning is 9 and @side is "Bottom" and @outs is 3
