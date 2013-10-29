class @Pitching

  PITCH_BALL_PROB = 50
  PITCH_STRIKE_PROB = 35
  PITCH_CONTACT_PROB = 100 - PITCH_BALL_PROB - PITCH_STRIKE_PROB

  PITCH_BALL_RANGE = [0, PITCH_BALL_PROB]
  PITCH_STRIKE_RANGE = [(PITCH_BALL_PROB), PITCH_BALL_PROB + PITCH_STRIKE_PROB]
  PITCH_CONTACT_RANGE = [(PITCH_BALL_PROB + PITCH_STRIKE_PROB), 100]

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
