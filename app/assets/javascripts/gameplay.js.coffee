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

  baseOccupancy = { first: "empty", second: "empty", third: "empty" }

  # Pitch Results
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


  # Contact results
  contact: ->
    Math.floor (Math.random() * 100) + 1

  contactResult: (contact) ->
    if @inFoulRange(contact) then return "foul"
    if @inSingleRange(contact) then return "single"
    if @inDoubleRange(contact) then return "double"
    if @inTripleRange(contact) then return "triple"
    if @inHomeRunRange(contact) then return "home run"
    if @inPopFlyOutRange(contact) then return "pop fly out"
    if @inGroundBallOutRange(contact) then return "ground ball out"

  inFoulRange: (contact) ->
    contact > CONTACT_FOUL_RANGE[0] && contact <= CONTACT_FOUL_RANGE[1]

  inSingleRange: (contact) ->
    contact > CONTACT_SINGLE_RANGE[0] && contact <= CONTACT_SINGLE_RANGE[1]

  inDoubleRange: (contact) ->
    contact > CONTACT_DOUBLE_RANGE[0] && contact <= CONTACT_DOUBLE_RANGE[1]

  inTripleRange: (contact) ->
    contact > CONTACT_TRIPLE_RANGE[0] && contact <= CONTACT_TRIPLE_RANGE[1]

  inHomeRunRange: (contact) ->
    contact > CONTACT_HOME_RUN_RANGE[0] && contact <= CONTACT_HOME_RUN_RANGE[1]

  inPopFlyOutRange: (contact) ->
    contact > CONTACT_POP_FLY_OUT_RANGE[0] && contact <= CONTACT_POP_FLY_OUT_RANGE[1]

  inGroundBallOutRange: (contact) ->
    contact > CONTACT_GROUND_BALL_OUT_RANGE[0] && contact <= CONTACT_GROUND_BALL_OUT_RANGE[1]

  # At-bat
  atbat: ->
    balls = 0
    strikes = 0
    contact = null
    atbat = true

    while atbat
      result = @pitchResult(@pitch())
      switch result
        when "ball" then balls = @ballReceived(balls)
        when "strike" then strikes = @strikeReceived(strikes)
        when "contact" then @contactReceived()
      if balls is 4
        @display_clear_balls()
        result = "walk"
        atbat = false
      if strikes is 3
        @display_clear_strikes()
        result = "strikeout"
        atbat = false
      if contact is "foul"
        strikes = @strikeReceived(contact, strikes)
      if contact? and contact isnt "foul"
        result = contact
        atbat = false

    return result

  ballReceived: (balls) ->
    @displayAddBall()
    return balls + 1

  strikeReceived: (contact, strikes) ->
    if contact is "foul" and strikes is 2
      return strikes
    @displayAddStrike()
    return strikes + 1

  contactReceived: (contact) ->
    result = @contactResult()
    @displayAddGameReport(result) unless result is "foul"
    @updateBaseOccupancy(result)

  updateBaseOccupancy: (result) ->
    if result is "single"
      if baseOccupancy.first is "empty"
        baseOccupancy.first("manned")
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(1)
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "empty"
        baseOccupancy.first("manned")
        baseOccupancy.second("manned")
        baseOccupancy.third("manned")
      else if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "man"
        baseOccupancy.first("manned")
        baseOccupancy.second("manned")
        baseOccupancy.third("manned")
    if result is "double"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(2)
        baseOccupancy.first("empty")
        baseOccupancy.second("manned")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(2)
        baseOccupancy.first("empty")
        baseOccupancy.second("manned")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        @runScored(1)
        baseOccupancy.first("empty")
        baseOccupancy.second("manned")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        @runScored(1)
        baseOccupancy.first("empty")
        baseOccupancy.second("manned")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first("empty")
        baseOccupancy.second("manned")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first("empty")
        baseOccupancy.second("manned")
        baseOccupancy.third("empty")
    if result is "triple"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(3)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(2)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        @runScored(2)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        @runScored(1)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        @runScored(1)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("manned")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("manned")
    if result is "home run"
      if baseOccupancy.first is "manned" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(4)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "manned" and baseOccupancy.third is "manned"
        @runScored(3)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        @runScored(3)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "manned"
        @runScored(2)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "manned" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        @runScored(2)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("empty")
      if baseOccupancy.first is "empty" and baseOccupancy.second is "empty" and baseOccupancy.third is "empty"
        @runScored(1)
        baseOccupancy.first("empty")
        baseOccupancy.second("empty")
        baseOccupancy.third("empty")
    if result is "pop fly out"
        @displayAddOut()
    if result is "ground ball out"
        @displayAddOut()

  # inning controller
  inningController: ->
    outs = 0
    @displayAddGameReport("First Inning")
    while outs < 3
      @atbat()

  # display
  displayAddBall: (balls) ->
    $("#gameplay-at-bat-ball-indicator#{balls}").removeClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator#{balls}").addClass("glyphicon glyphicon-checked")

  displayAddStrike: (strikes) ->
    $("#gameplay-at-bat-strike-indicator#{strikes}").removeClass("glyphicon glyphicon-checked")
    $("#gameplay-at-bat-strike-indicator#{strikes}").addClass("glyphicon glyphicon-checked")

  displayAddOut: ->
    if $("#gameplay-at-bat-out-indicator1").hasClass("glyphicon-checked")
      $("#gameplay-at-bat-out-indicator1").removeClass("glyphicon glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator1").addClass("glyphicon glyphicon-checked")
    else
      $("#gameplay-at-bat-out-indicator2").removeClass("glyphicon glyphicon-unchecked")
      $("#gameplay-at-bat-out-indicator2").addClass("glyphicon glyphicon-checked")


  displayClearBalls: ->
    $("#gameplay-at-bat-ball-indicator1").removeClass("glyphicon glyphicon-checked")
    $("#gameplay-at-bat-ball-indicator2").removeClass("glyphicon glyphicon-checked")
    $("#gameplay-at-bat-ball-indicator3").removeClass("glyphicon glyphicon-checked")
    $("#gameplay-at-bat-ball-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator2").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-ball-indicator3").addClass("glyphicon glyphicon-unchecked")

  displayClearStrikes: ->
    $("#gameplay-at-bat-strike-indicator1").removeClass("glyphicon glyphicon-checked")
    $("#gameplay-at-bat-strike-indicator2").removeClass("glyphicon glyphicon-checked")
    $("#gameplay-at-bat-strike-indicator1").addClass("glyphicon glyphicon-unchecked")
    $("#gameplay-at-bat-strike-indicator2").addClass("glyphicon glyphicon-unchecked")


  displayAddGameReport: (report) ->
    $("#gameplay-game-report").append(report)
