#= require underscore

$(document).ready ->
  game = new Gameplay()

  $("#start-button").on "click", ->
    game.playGame()

class @Gameplay

  atBatResult: (result) ->
    switch result
      when "strikeout" then @displayAddGameReport("Strike out")
      when "pop fly out" then @displayAddGameReport("Pop out")
      when "ground ball out" then @displayAddGameReport("Ground out")
      else
        @displayAddGameReport(@capitaliseFirstLetter(result))
        score = @updateBaseOccupancy(baseOccupancy, result, score)
    return { result: result, score: score }

  # display
  displayAddBall: (balls) ->
    $("#gameplay-at-bat-ball-indicator#{balls}").removeClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator#{balls}").addClass("glyphicon glyphicon-check")

  displayAddStrike: (strikes) ->
    $("#gameplay-at-bat-strike-indicator#{strikes}").removeClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-strike-indicator#{strikes}").addClass("glyphicon glyphicon-check")

  displayAddOut: ->
    if $("#gameplay-at-bat-out-indicator1").hasClass("glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-check")
    else
      $("#gameplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-check")

  displayClearBalls: ->
    $("#gameplay-at-bat-ball-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-ball-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-ball-indicator3").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-ball-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator2").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator3").addClass("glyphicon glyphicon-unchecked")

  displayClearStrikes: ->
    $("#gameplay-at-bat-strike-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-strike-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-strike-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-strike-indicator2").addClass("glyphicon glyphicon-unchecked")

  displayClearOuts: ->
    $("#gameplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-check")
    $("#gameplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-unchecked")

  displayAddGameReport: (report) ->
    $("#gameplay-game-report").append(report + "<br>")

  displayUpdateScoreboard: (score, inning, side) ->
    $("#gameplay-scoreboard-#{side}-inning-#{inning}").text(score)
    @displayUpdateScoreboardTotal(score, inning, side)

  displayUpdateScoreboardTotal: (score, inning, side) ->
    currentTotal = parseInt($("#gameplay-scoreboard-#{side}-total").text(), 10)
    $("#gameplay-scoreboard-#{side}-total").text(score + currentTotal)

  displayUpdateBaseOccupancy: (bases) ->
    $("#baseball-field-first-base-runner").show() if bases.first is "manned"
    $("#baseball-field-first-base-runner").hide() if bases.first is "empty"
    $("#baseball-field-second-base-runner").show() if bases.second is "manned"
    $("#baseball-field-second-base-runner").hide() if bases.second is "empty"
    $("#baseball-field-third-base-runner").show() if bases.third is "manned"
    $("#baseball-field-third-base-runner").hide() if bases.third is "empty"

  # display helpers
  capitaliseFirstLetter: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)
