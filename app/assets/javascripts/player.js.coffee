class @Player
  constructor: (name, position, profile) ->
    @name = name
    @position = position
    @profile = profile
    @prob = @playerProbability()

  playerProbability: () ->
    new Probabilities(@profile.batting_power, @profile.batting_contact, @profile.pitching)
