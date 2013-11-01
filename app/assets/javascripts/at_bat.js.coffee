class @AtBat
  constructor: (@pitcher, @contact, @baseRunner, @display, @baseOccupancy) ->
    @balls = 0
    @strikes = 0
    @complete = null
    @baseOccupancy ?= @baseRunner.basesEmpty()
    @isOut = false

  atbat: (pitch) ->
    switch pitch
      when "ball" then @ballReceived()
      when "strike" then @strikeReceived()
      when "contact" then contact = @contact.contactReceived(@contact.contact())

    if contact is "foul"
      strikes = @strikeReceived(contact)

    if contact? and contact isnt "foul"
      @batterMadeContact(contact)
    else
      @walkOrStrikeOutCheck()

  batterMadeContact:(contact) ->
    switch contact
      when "strikeout"
        @isOut = true
        @complete = "Strikeout"
      when "pop fly out"
        @isOut = true
        @complete = "Pop Fly Out"
      when "ground ball out"
        @isOut = true
        @complete = "Ground Ball Out"
      else
        @baseOccupancy = @baseRunner.updateBaseOccupancy(@baseOccupancy, contact)
        @complete = contact

  makePitch: ->
    @atbat(@pitcher.pitchResult(@pitcher.pitch()))

  ballReceived: ->
    @balls += 1
    @display.addGameReport("Ball", "hyphenated")

  strikeReceived: (contact) ->
    unless contact is "foul" and @strikes is 2
      @strikes += 1
      @display.addGameReport("Strike", "hyphenated")

  walkOrStrikeOutCheck: ->
    if @balls is 4
      @baseOccupancy = @baseRunner.updateBaseOccupancy(@baseOccupancy, "walk")
      @complete = "Walk"
    else if @strikes is 3
      @isOut = true
      @complete = "Strikeout"
    else
      @complete = null
