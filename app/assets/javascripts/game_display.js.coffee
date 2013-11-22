#= require underscore

$(document).ready ->
  game = new Game(1, 3)

  $("#start-button").on "click", ->
    game.pitch()

class @GameDisplay
  constructor: ->
    @reporter = $("#gamedisplay-game-report")
    @height = $("#gamedisplay-game-report").height()
    @gameStarted = false
    @addGameReport("Play ball", "heading")

  testMessage: ->
    @reporter.append "The away team name is #{@game.awayTeam.name}"

  startGame: ->
    unless @gameStarted
      @inning()
      @pitcher()
      @nextBatter()
      @gameStarted = true

  inning: ->
    @addGameReport("Inning #{@game.inning} - #{@game.side}", "outline")

  nextBatter: ->
    @addGameReport("Next Batter", "nextBatter")
    @addGameReport(@game.batter.name, "nextBatter")
    $("td:contains(#{@lastBatterName})").removeClass("gamedisplay-current-batter")
    $("td:contains(#{@game.batter.name})").addClass("gamedisplay-current-batter")
    @lastBatterName = @game.batter.name

  gameFinished: ->
    @reporter.scrollTop(0)
    @addGameReport("Game Over", "gameover")

  battingOrder: (awayPlayers, homePlayers) ->
    awayBattingLineupNames = _.map([1..9], (num) -> $("#gamedisplay-away-batter-#{num}-name"))
    _.each(awayPlayers, (value, key, list) -> awayBattingLineupNames[key].text(value.name))

    awayBattingLineupPositions = _.map([1..9], (num) -> $("#gamedisplay-away-batter-#{num}-position"))
    _.each(awayPlayers, (value, key, list) -> awayBattingLineupPositions[key].text(value.position))

    homeBattingLineupNames = _.map([1..9], (num) -> $("#gamedisplay-home-batter-#{num}-name"))
    _.each(homePlayers, (value, key, list) -> homeBattingLineupNames[key].text(value.name))

    homeBattingLineupPositions = _.map([1..9], (num) -> $("#gamedisplay-home-batter-#{num}-position"))
    _.each(homePlayers, (value, key, list) -> homeBattingLineupPositions[key].text(value.position))

  pitcher: ->
    if @game.side is "Top"
      $("#gamedisplay-away-pitcher-name").removeClass("gamedisplay-current-pitcher")
      $("#gamedisplay-home-pitcher-name").addClass("gamedisplay-current-pitcher")
    else if @game.side is "Bottom"
      $("#gamedisplay-home-pitcher-name").removeClass("gamedisplay-current-pitcher")
      $("#gamedisplay-away-pitcher-name").addClass("gamedisplay-current-pitcher")

  pitchers:(awayPitcher, homePitcher) ->
    $("#gamedisplay-away-pitcher-name").text(awayPitcher.name)
    $("#gamedisplay-home-pitcher-name").text(homePitcher.name)

  teamsPlaying: (away, home) ->
    $("#away-team-name").text(away)
    $("#home-team-name").text(home)

  updateDisplay: (atBat) ->
    unless atBat.balls is 0
      balls = [1..atBat.balls]
      for ball in balls
        @addBall(ball)
    unless atBat.strikes is 0
      strikes = [1..atBat.strikes]
      for strike in strikes
        @addStrike(strike)
    @updateBaseOccupancy(atBat.baseOccupancy)
    if atBat.complete and (atBat.complete isnt /out/.test(atBat.complete))
      @addGameReport(@capitaliseFirstLetter(atBat.complete), "result")
    @pitcher()

  updateOuts: ->
    @addOut()

  addBall: (balls) ->
    $("#gamedisplay-at-bat-ball-indicator#{balls}").removeClass("glyphicon glyphicon-unchecked")
    $("#gamedisplay-at-bat-ball-indicator#{balls}").addClass("glyphicon glyphicon-check")

  addStrike: (strikes) ->
    $("#gamedisplay-at-bat-strike-indicator#{strikes}").removeClass("glyphicon glyphicon-unchecked")
    $("#gamedisplay-at-bat-strike-indicator#{strikes}").addClass("glyphicon glyphicon-check")

  addOut: ->
    if $("#gamedisplay-at-bat-out-indicator1").hasClass("glyphicon-unchecked")
      $("#gamedisplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-unchecked")
      $("#gamedisplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-check")
    else
      $("#gamedisplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-unchecked")
      $("#gamedisplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-check")

  clearAll: ->
    @clearBalls()
    @clearStrikes()
    @clearOuts()

  clearBatter: ->
    @clearBalls()
    @clearStrikes()

  clearBalls: ->
    $("#gamedisplay-at-bat-ball-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-ball-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-ball-indicator3").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-ball-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gamedisplay-at-bat-ball-indicator2").addClass("glyphicon glyphicon-unchecked")
    $("#gamedisplay-at-bat-ball-indicator3").addClass("glyphicon glyphicon-unchecked")

  clearStrikes: ->
    $("#gamedisplay-at-bat-strike-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-strike-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-strike-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gamedisplay-at-bat-strike-indicator2").addClass("glyphicon glyphicon-unchecked")

  clearOuts: ->
    $("#gamedisplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gamedisplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gamedisplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-unchecked")

  updateScoreboard: (score, inning, side) ->
    $("#gamedisplay-scoreboard-#{side.toLowerCase()}-inning-#{inning}").text(score)
    @updateScoreboardTotal(score, inning, side)

  updateScoreboardTotal: (score, inning, side) ->
    innings = [1..inning]
    totalTopScore = 0
    totalBottomScore = 0

    for inn in innings
      topScore = parseInt($("#gamedisplay-scoreboard-top-inning-#{inn}").text(), 10)
      if topScore
        totalTopScore += topScore
    for inn in innings
      bottomScore = parseInt($("#gamedisplay-scoreboard-bottom-inning-#{inn}").text(), 10)
      if bottomScore
        totalBottomScore += bottomScore

    $("#gamedisplay-scoreboard-top-total").text(totalTopScore)
    $("#gamedisplay-scoreboard-bottom-total").text(totalBottomScore)

  updateBaseOccupancy: (bases) ->
    $("#baseball-field-first-base-runner").show() if bases.first is "manned"
    $("#baseball-field-first-base-runner").hide() if bases.first is "empty"
    $("#baseball-field-second-base-runner").show() if bases.second is "manned"
    $("#baseball-field-second-base-runner").hide() if bases.second is "empty"
    $("#baseball-field-third-base-runner").show() if bases.third is "manned"
    $("#baseball-field-third-base-runner").hide() if bases.third is "empty"

  # display helpers
  capitaliseFirstLetter: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  addGameReport: (report, option) ->
    switch option
      when "doubleBreak" then @reporter.append("<br>" + report + "<br>")
      when "hyphenated" then @reporter.append('<span id="gamedisplay-game-report-balls-strikes">' + report + ' | </span>')
      when "bold" then @reporter.append("<b>" + report + "</b>")
      when "heading" then @reporter.append("<h2>" + report + "</h2>")
      when "emphasis" then @reporter.append("<h4>" + report + "</h4><br>")
      when "outline" then @reporter.append('<div id="gamedisplay-game-report-outline">' + report + '</div><br>')
      when "nextBatter" then @reporter.append('<div id="gamedisplay-game-report-next-batter">' + report + '</div>')
      when "result" then @reporter.append('<div id="gamedisplay-game-report-result">' + report + '</div>')
      when "gameover" then @reporter.append('<div id="gamedisplay-game-report-game-over">' + report + '</div>')

    #@reporter.animate({scrollTop: @height}, "fast")
    #@height += @reporter.height()
