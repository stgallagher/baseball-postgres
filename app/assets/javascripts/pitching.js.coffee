class @Pitching(probabilty)

  PITCH_BALL_RANGE = [0, probability.pitchBall]
  PITCH_STRIKE_RANGE = [(probability.pitchBall), probability.pitchBall + probability.pitchStrike]
  PITCH_CONTACT_RANGE = [(probability.pitchBall + probability.pitchStrike), 100]

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
