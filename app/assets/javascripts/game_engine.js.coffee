class @GameEngine

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

  #atBatResult: (result, score, baseOccupancy) ->
  #  switch result
  #    when "strikeout" then @displayAddGameReport("Strike out")
  #    when "pop fly out" then @displayAddGameReport("Pop out")
  #    when "ground ball out" then @displayAddGameReport("Ground out")
  #    else
  #      @displayAddGameReport(@capitaliseFirstLetter(result))
  #      score = @updateBaseOccupancy(baseOccupancy, result, score)
  #  return { result: result, score: score }

  ballReceived: (balls) ->
    #@displayAddBall(balls + 1)
    return balls + 1

  strikeReceived: (contact, strikes) ->
    if contact is "foul" and strikes is 2
      return strikes
    #@displayAddStrike(strikes + 1)
    return strikes + 1


  # play inning
  playInning: (score) ->
    outs = 0
    baseOccupancy = { first: "empty", second: "empty", third: "empty" }

    while outs < 3
      result = @atbat()
      battingResult = @atBatResult(result, score, baseOccupancy)
      if battingResult.result is "strikeout" or battingResult.result is "pop fly out" or battingResult.result is "ground ball out"
        outs += 1
      score = battingResult.score
      #@displayAddOut()
      #@displayClearBalls()
      #@displayClearStrikes()

    return score

  playGame: () ->
    score = 0
    innings = [1..9]

    #@displayAddGameReport("<h3>PLAY BALL!!!</h3>")
    while innings.length isnt 0
      inning = innings.shift()

      if inning < 10
        #@displayAddGameReport("<br><b>#{inning} Inning - Top</b>")
        side = "away"
        score = @playInning(score)
        #@displayUpdateScoreboard(score, inning, side)
        score = 0

        #@displayAddGameReport("<br><b>#{inning} Inning - Bottom</b>")
        side = "home"
        score = @playInning(score)
        #@displayUpdateScoreboard(score, inning, side)
        score = 0
