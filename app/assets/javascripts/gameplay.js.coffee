#= require underscore

$(document).ready ->
  homeTeam = new Team()
  awayTeam = new Team()
  game = new GameEngine(homeTeam, awayTeam)
  simulator = new Simulator(game)

  $("#start-button").on "click", ->
    game.makePitch()
    #simulator.simulateGame()

class @Gameplay
  constructor: ->
    @reporter = $("#gameplay-game-report")
    @height = $("#gameplay-game-report").height()

  gameFinished: ->
    @reporter.scrollTop(0)
    @addGameReport("Game Over", "gameover")

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

  updateOuts: ->
    @addOut()

  addBall: (balls) ->
    $("#gameplay-at-bat-ball-indicator#{balls}").removeClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator#{balls}").addClass("glyphicon glyphicon-check")

  addStrike: (strikes) ->
    $("#gameplay-at-bat-strike-indicator#{strikes}").removeClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-strike-indicator#{strikes}").addClass("glyphicon glyphicon-check")

  addOut: ->
    if $("#gameplay-at-bat-out-indicator1").hasClass("glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-check")
    else
      $("#gameplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-check")

  clearAll: ->
    @clearBalls()
    @clearStrikes()
    @clearOuts()

  clearBatter: ->
    @clearBalls()
    @clearStrikes()

  clearBalls: ->
    $("#gameplay-at-bat-ball-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-ball-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-ball-indicator3").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-ball-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator2").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator3").addClass("glyphicon glyphicon-unchecked")

  clearStrikes: ->
    $("#gameplay-at-bat-strike-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-strike-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-strike-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-strike-indicator2").addClass("glyphicon glyphicon-unchecked")

  clearOuts: ->
    $("#gameplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-unchecked")

  updateScoreboard: (score, inning, side) ->
    $("#gameplay-scoreboard-#{side.toLowerCase()}-inning-#{inning}").text(score)
    @updateScoreboardTotal(score, inning, side)

  updateScoreboardTotal: (score, inning, side) ->
    innings = [1..inning]
    totalTopScore = 0
    totalBottomScore = 0

    for inn in innings
      topScore = parseInt($("#gameplay-scoreboard-top-inning-#{inn}").text(), 10)
      if topScore
        totalTopScore += topScore
    for inn in innings
      bottomScore = parseInt($("#gameplay-scoreboard-bottom-inning-#{inn}").text(), 10)
      if bottomScore
        totalBottomScore += bottomScore

    $("#gameplay-scoreboard-top-total").text(totalTopScore)
    $("#gameplay-scoreboard-bottom-total").text(totalBottomScore)

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
      when "hyphenated" then @reporter.append('<span id="gameplay-game-report-balls-strikes">' + report + ' | </span>')
      when "bold" then @reporter.append("<b>" + report + "</b>")
      when "heading" then @reporter.append("<h2>" + report + "</h2>")
      when "emphasis" then @reporter.append("<h4>" + report + "</h4><br>")
      when "outline" then @reporter.append('<div id="gameplay-game-report-outline">' + report + '</div><br>')
      when "nextBatter" then @reporter.append('<div id="gameplay-game-report-next-batter">' + report + '</div>')
      when "result" then @reporter.append('<div id="gameplay-game-report-result">' + report + '</div>')
      when "gameover" then @reporter.append('<div id="gameplay-game-report-game-over">' + report + '</div>')

    #@reporter.animate({scrollTop: @height}, "fast")
    #@height += @reporter.height()
