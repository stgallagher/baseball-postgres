class @Contact

  constructor: () ->
    @foul = null
    @single = null
    @double = null
    @triple = null
    @homerun = null
    @popflyout == null

  CONTACT_FOUL_RANGE = null
  CONTACT_SINGLE_RANGE = null
  CONTACT_DOUBLE_RANGE = null
  CONTACT_TRIPLE_RANGE = null
  CONTACT_HOME_RUN_RANGE = null
  CONTACT_POP_FLY_OUT_RANGE = null
  CONTACT_GROUND_BALL_OUT_RANGE = null

  # Contact
  contact: ->
    Math.floor (Math.random() * 100) + 1

  newBatter: (player) ->
    @foul = player.prob.contactProb.foul
    @single = player.prob.contactProb.single
    @double = player.prob.contactProb.double
    @triple = player.prob.contactProb.triple
    @homerun = player.prob.contactProb.homerun
    @popflyout = player.prob.contactProb.popflyout

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
    CONTACT_FOUL_RANGE = [0, @foul]
    CONTACT_SINGLE_RANGE = [@foul + 1, @foul + @single]
    CONTACT_DOUBLE_RANGE = [@foul + @single + 1, @foul + @single + @double]
    CONTACT_TRIPLE_RANGE = [@foul + @single + @double + 1, @foul + @single + @double + @triple]
    CONTACT_HOME_RUN_RANGE = [@foul + @single + @double + @triple + 1, @foul + @single + @double + @triple + @homerun]
    CONTACT_POP_FLY_OUT_RANGE = [@foul + @single + @double + @triple + @homerun, @foul + @single + @double + @triple + @homerun + @popflyout]
    CONTACT_GROUND_BALL_OUT_RANGE = [@foul + @single + @double + @triple + @homerun + @popflyout + 1, 100]

    if @inFoulRange(contact) then return "foul"
    if @inSingleRange(contact) then return "single"
    if @inDoubleRange(contact) then return "double"
    if @inTripleRange(contact) then return "triple"
    if @inHomeRunRange(contact) then return "homerun"
    if @inPopFlyOutRange(contact) then return "pop fly out"
    if @inGroundBallOutRange(contact) then return "ground ball out"

