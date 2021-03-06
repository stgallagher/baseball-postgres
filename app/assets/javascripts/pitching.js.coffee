class @Pitching

  constructor: () ->
    @ball = null
    @strike = null

  PITCH_BALL_RANGE = null
  PITCH_STRIKE_RANGE = null
  PITCH_CONTACT_RANGE = null

  makePitch: ->
    @pitchResult(@pitch())

  pitch: ->
    Math.floor (Math.random() * 100) + 1

  newPitcher: (atbat) ->
    @ball = atbat.pitchingProb.ball
    @strike = atbat.pitchingProb.strike

  inBallRange: (pitch) ->
    pitch > PITCH_BALL_RANGE[0] && pitch <= PITCH_BALL_RANGE[1]

  inStrikeRange: (pitch) ->
    pitch > PITCH_STRIKE_RANGE[0] && pitch <= PITCH_STRIKE_RANGE[1]

  inContactRange: (pitch) ->
    pitch > PITCH_CONTACT_RANGE[0] && pitch <= PITCH_CONTACT_RANGE[1]

  pitchResult: (pitch) ->
    PITCH_BALL_RANGE = [0, @ball]
    PITCH_STRIKE_RANGE = [@ball, @ball + @strike]
    PITCH_CONTACT_RANGE = [@ball + @strike, 100]

    if @inBallRange(pitch) then return "ball"
    if @inStrikeRange(pitch) then return "strike"
    if @inContactRange(pitch) then return "contact"
