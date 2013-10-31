#= require underscore

$(document).ready ->
  game = new GameEngine()

  $("#start-button").on "click", ->
    game.makePitch()

class @Gameplay

  gameFinished: ->
    @addGameReport("GAME OVER, MAN")

  updateDisplay: (atBat) ->
    unless atBat.balls is 0
      balls = [1..atBat.balls]
      for ball in balls
        @addBall(ball)
      #_.each(balls, (ball) -> @addBall(ball))
    unless atBat.strikes is 0
      strikes = [1..atBat.strikes]
      for strike in strikes
        @addStrike(strike)
     # _.each(strikes, (strike) -> @addStrike(strike))
     @updateBaseOccupancy(atBat.baseOccupancy)
     @addGameReport(JSON.stringify(atBat.complete)) if atBat.complete

  updateOuts: (outs) ->
      out = [1..outs]
      for o in out
        @addOut(o)
      #_.each(out, (num) -> @addOut(num))

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
    $("#gameplay-scoreboard-#{side}-inning-#{inning}").text(score)
    @updateScoreboardTotal(score, inning, side)

  updateScoreboardTotal: (score, inning, side) ->
    currentTotal = parseInt($("#gameplay-scoreboard-#{side}-total").text(), 10)
    $("#gameplay-scoreboard-#{side}-total").text(score + currentTotal)

  updateBaseOccupancy: (bases) ->
    console.log("GAMEPLAY::updateBaseOccupancy -> bases = #{JSON.stringify(bases)}")


    $("#baseball-field-first-base-runner").show() if bases.first is "manned"
    $("#baseball-field-first-base-runner").hide() if bases.first is "empty"
    $("#baseball-field-second-base-runner").show() if bases.second is "manned"
    $("#baseball-field-second-base-runner").hide() if bases.second is "empty"
    $("#baseball-field-third-base-runner").show() if bases.third is "manned"
    $("#baseball-field-third-base-runner").hide() if bases.third is "empty"

  # display helpers
  capitaliseFirstLetter: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  addGameReport: (report) ->
    $("#gameplay-game-report").append(report + "<br>")
