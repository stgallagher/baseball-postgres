class @Contact

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

  contactReceived: (contact) ->
    if @inFoulRange(contact) then return "foul"
    if @inSingleRange(contact) then return "single"
    if @inDoubleRange(contact) then return "double"
    if @inTripleRange(contact) then return "triple"
    if @inHomeRunRange(contact) then return "home run"
    if @inPopFlyOutRange(contact) then return "pop fly out"
    if @inGroundBallOutRange(contact) then return "ground ball out"
