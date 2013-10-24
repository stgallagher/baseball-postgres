$(document).ready ->
  $("#start-button").on "click", ->
    game = new Gameplay()
    game.playGame()

class @Gameplay
  PITCH_BALL_PROB = 50
  PITCH_STRIKE_PROB = 35
  PITCH_CONTACT_PROB = 100 - PITCH_BALL_PROB - PITCH_STRIKE_PROB

  PITCH_BALL_RANGE = [0, PITCH_BALL_PROB]
  PITCH_STRIKE_RANGE = [(PITCH_BALL_PROB) + 1, PITCH_BALL_PROB + PITCH_STRIKE_PROB]
  PITCH_CONTACT_RANGE = [(PITCH_BALL_PROB + PITCH_STRIKE_PROB) + 1, 100]

  CONTACT_FOUL_PROB = 35
  CONTACT_SINGLE_PROB = 15
  CONTACT_DOUBLE_PROB = 5
  CONTACT_TRIPLE_PROB = 1
  CONTACT_HOME_RUN_PROB = 4
  CONTACT_POP_FLY_OUT_PROB = 20
  CONTACT_GROUND_BALL_OUT_PROB = 20

  CONTACT_FOUL_RANGE = [0, CONTACT_FOUL_PROB]
  CONTACT_SINGLE_RANGE = [CONTACT_FOUL_PROB + 1, CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB]
  CONTACT_DOUBLE_RANGE = [CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + 1, CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB]
  CONTACT_TRIPLE_RANGE = [CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + 1, CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + CONTACT_TRIPLE_PROB]
  CONTACT_HOME_RUN_RANGE = [CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + CONTACT_TRIPLE_PROB + 1, CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + CONTACT_TRIPLE_PROB + CONTACT_HOME_RUN_PROB]
  CONTACT_POP_FLY_OUT_RANGE = [CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + CONTACT_TRIPLE_PROB + CONTACT_HOME_RUN_PROB, CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + CONTACT_TRIPLE_PROB + CONTACT_HOME_RUN_PROB + CONTACT_POP_FLY_OUT_PROB]
  CONTACT_GROUND_BALL_OUT_RANGE = [CONTACT_FOUL_PROB + CONTACT_SINGLE_PROB + CONTACT_DOUBLE_PROB + CONTACT_TRIPLE_PROB + CONTACT_HOME_RUN_PROB + CONTACT_POP_FLY_OUT_PROB + 1, 100]


  # Pitch
  pitch: ->
    Math.floor (Math.random() * 100) + 1

  pitchResult: (pitch) ->
    if @inBallRange(pitch) then return "ball"
    if @inStrikeRange(pitch) then return "strike"
    if @inContactRange(pitch) then return "contact"

  inBallRange: (pitch) ->
    pitch > PITCH_BALL_RANGE[0] && pitch <= PITCH_BALL_RANGE[1]

  inStrikeRange: (pitch) ->
    pitch > PITCH_STRIKE_RANGE[0] && pitch <= PITCH_STRIKE_RANGE[1]

  inContactRange: (pitch) ->
    pitch > PITCH_CONTACT_RANGE[0] && pitch <= PITCH_CONTACT_RANGE[1]


  # Contact
  contact: ->
    Math.floor (Math.random() * 100) + 1

  inFoulRange: (contact) ->
    contact >= CONTACT_FOUL_RANGE[0] && contact <= CONTACT_FOUL_RANGE[1]

  inSingleRange: (contact) ->
    contact >= CONTACT_SINGLE_RANGE[0] && contact <= CONTACT_SINGLE_RANGE[1]

  inDoubleRange: (contact) ->
    contact >= CONTACT_DOUBLE_RANGE[0] && contact <= CONTACT_DOUBLE_RANGE[1]

  inTripleRange: (contact) ->
    contact >= CONTACT_TRIPLE_RANGE[0] && contact <= CONTACT_TRIPLE_RANGE[1]

  inHomeRunRange: (contact) ->
    contact >= CONTACT_HOME_RUN_RANGE[0] && contact <= CONTACT_HOME_RUN_RANGE[1]

  inPopFlyOutRange: (contact) ->
    contact >= CONTACT_POP_FLY_OUT_RANGE[0] && contact <= CONTACT_POP_FLY_OUT_RANGE[1]

  inGroundBallOutRange: (contact) ->
    contact >= CONTACT_GROUND_BALL_OUT_RANGE[0] && contact <= CONTACT_GROUND_BALL_OUT_RANGE[1]

  # At-bat
  atbat: ->
    balls = 0
    strikes = 0
    contact = null
    atbat = true

    while atbat
      result = @pitchResult(@pitch())
      #@displayAddGameReport("@atbat: Pitch Result -> result = #{result}")
      switch result
        when "ball" then balls = @ballReceived(balls)
        when "strike" then strikes = @strikeReceived(contact, strikes)
        when "contact" then contact = @contactReceived(@contact())

      if balls is 4
        result = "walk"
        atbat = false

      if strikes is 3
        result = "strikeout"
        atbat = false

      if contact is "foul"
        strikes = @strikeReceived(contact, strikes)

      if contact? and contact isnt "foul"
        result = contact
        atbat = false
      contact = null

      #@displayAddGameReport("@atbat: balls = #{balls}, strikes = #{strikes}, contact = #{contact}")

    return result

  atBatResult: (result, score, baseOccupancy) ->
    switch result
      when "strikeout" then @displayAddGameReport("Strike out")
      when "pop fly out" then @displayAddGameReport("Pop out")
      when "ground ball out" then @displayAddGameReport("Ground out")
      else
        @displayAddGameReport(@capitaliseFirstLetter(result))
        score = @updateBaseOccupancy(baseOccupancy, result, score)
    return { result: result, score: score }

  ballReceived: (balls) ->
    @displayAddBall(balls + 1)
    return balls + 1

  strikeReceived: (contact, strikes) ->
    if contact is "foul" and strikes is 2
      return strikes
    @displayAddStrike(strikes + 1)
    return strikes + 1

  contactReceived: (contact) ->
    if @inFoulRange(contact) then return "foul"
    if @inSingleRange(contact) then return "single"
    if @inDoubleRange(contact) then return "double"
    if @inTripleRange(contact) then return "triple"
    if @inHomeRunRange(contact) then return "home run"
    if @inPopFlyOutRange(contact) then return "pop fly out"
    if @inGroundBallOutRange(contact) then return "ground ball out"

  updateBaseOccupancy: (baseOccupancy, result, score) ->
    if result is "walk"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
    if result is "single"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "manned"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "manned"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "manned"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
    if result is "double"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "empty"
        baseOccupancy.second = "manned"
        baseOccupancy.third = "empty"
    if result is "triple"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 3
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "manned"
    if result is "home run"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 4
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        score += 3
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        score += 3
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 3
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        score += 2
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"
      else if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        score += 1
        baseOccupancy.first = "empty"
        baseOccupancy.second = "empty"
        baseOccupancy.third = "empty"

    @displayUpdateBaseOccupancy(baseOccupancy)
    return score

  # play inning
  playInning: (score) ->
    outs = 0
    baseOccupancy = { first: "empty", second: "empty", third: "empty" }

    while outs < 3
      result = @atbat()
      battingResult = @atBatResult(result, score, baseOccupancy)
      if battingResult.result is "strikeout" or battingResult.result is "pop fly out" or battingResult.result is "ground ball out"
        outs += 1
      #@displayAddGameReport("<b>battingResult: #{JSON.stringify(battingResult)}</b>")
      score = battingResult.score
      @displayAddOut()
      @displayClearBalls()
      @displayClearStrikes()

    return score

  playGame: ->
    score = 0
    innings = [1..9]

    @displayAddGameReport("<h3>PLAY BALL!!!</h3>")
    while innings.length isnt 0
      inning = innings.shift()

      @displayAddGameReport("<br><b>#{inning} Inning - Top</b>")
      side = "away"
      score = @playInning(score)
      @displayUpdateScoreboard(score, inning, side)
      score = 0

      @displayAddGameReport("<br><b>#{inning} Inning - Bottom</b>")
      side = "home"
      score = @playInning(score)
      @displayUpdateScoreboard(score, inning, side)
      score = 0

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
