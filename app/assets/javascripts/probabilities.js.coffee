class @Probabilities

  newProbabilities: (power, contact, pitching) ->
    @batterPower = power
    @batterContact = contact
    @pitcher = pitching
    @pitchingLevelMapper(@determinePitchLevel())
    @contactLevelMapper(@batterContact)


  determinePitchLevel: ->
    batterFactor = @batterContact - 3
    pitcherFactor = @pitcher - 3
    level = 5 + pitcherFactor - batterFactor

  pitchingLevelMapper: (level) ->
    switch level
      when 1 then @pitchingProb = PITCHING["one"]
      when 2 then @pitchingProb = PITCHING["two"]
      when 3 then @pitchingProb = PITCHING["three"]
      when 4 then @pitchingProb = PITCHING["four"]
      when 5 then @pitchingProb = PITCHING["five"]
      when 6 then @pitchingProb = PITCHING["six"]
      when 7 then @pitchingProb = PITCHING["seven"]
      when 8 then @pitchingProb = PITCHING["eight"]
      when 9 then @pitchingProb = PITCHING["nine"]

  contactLevelMapper: (level) ->
    switch level
      when 1 then @contactProb = CONTACT["one"]
      when 2 then @contactProb = CONTACT["two"]
      when 3 then @contactProb = CONTACT["three"]
      when 4 then @contactProb = CONTACT["four"]
      when 5 then @contactProb = CONTACT["five"]

  # Pitch
  # ---------------------------
  PITCHING =
    one:       ball: 30, strike: 15, contact: 55
    two:       ball: 25, strike: 20, contact: 55
    three:     ball: 20, strike: 25, contact: 55
    four:      ball: 18, strike: 35, contact: 47
    five:      ball: 15, strike: 40, contact: 45
    six:       ball: 13, strike: 45, contact: 42
    seven:     ball: 11, strike: 50, contact: 39
    eight:     ball: 10, strike: 55, contact: 35
    nine:      ball:  8, strike: 62, contact: 30

  # Contact
  # ---------------------------
  CONTACT =
     one:   foul: 35, single: 5,  double: 3,  triple: 1, homerun: 1,  popflyout: 30, groundout: 25
     two:   foul: 35, single: 10, double: 5,  triple: 1, homerun: 4,  popflyout: 22, groundout: 23
     three: foul: 35, single: 15, double: 5,  triple: 1, homerun: 4,  popflyout: 20, groundout: 20
     four:  foul: 35, single: 20, double: 8,  triple: 2, homerun: 5,  popflyout: 15, groundout: 15
     five:  foul: 35, single: 25, double: 10, triple: 5, homerun: 10, popflyout: 8,  groundout: 7
