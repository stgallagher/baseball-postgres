class @Contact(probabilty)

  CONTACT_FOUL_RANGE = [0, probability.contactFoul]
  CONTACT_SINGLE_RANGE = [probability.contactFoul + 1, probability.contactFoul + probability.contactSingle]
  CONTACT_DOUBLE_RANGE = [probability.contactFoul + probability.contactSingle + 1, probability.contactFoul + probability.contactSingle + probability.contactDouble]
  CONTACT_TRIPLE_RANGE = [probability.contactFoul + probability.contactSingle + probability.contactDouble + 1, probability.contactFoul + probability.contactSingle + probability.contactDouble + probability.contactTriple]
  CONTACT_HOME_RUN_RANGE = [probability.contactFoul + probability.contactSingle + probability.contactDouble + probability.contactTriple + 1, probability.contactFoul + probability.contactSingle + probability.contactDouble + probability.contactTriple + probability.contactHomeRun]
  CONTACT_POP_FLY_OUT_RANGE = [probability.contactFoul + probability.contactSingle + probability.contactDouble + probability.contactTriple + probability.contactHomeRun, probability.contactFoul + probability.contactSingle + probability.contactDouble + probability.contactTriple + probability.contactHomeRun + probability.contactPopFlyOut]
  CONTACT_GROUND_BALL_OUT_RANGE = [probability.contactFoul + probability.contactSingle + probability.contactDouble + probability.contactTriple + probability.contactHomeRun + probability.contactPopFlyOut + 1, 100]

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
    if @inHomeRunRange(contact) then return "homerun"
    if @inPopFlyOutRange(contact) then return "pop fly out"
    if @inGroundBallOutRange(contact) then return "ground ball out"
