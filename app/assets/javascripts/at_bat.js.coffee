class @AtBat
  constructor: (@pitcher, @contact, @baseRunner, @baseOccupancy) ->
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
      @complete = @batterMadeContact(contact)
    else
      @complete = @walkOrStrikeOutCheck()

  batterMadeContact:(contact) ->
    switch contact
      when "strikeout" then @isOut = true
      when "pop fly out" then @isOut = true
      when "ground ball out" then @isOut = true
      else
        @baseOccupancy = @baseRunner(@baseOccupancy, contact)

  makePitch: ->
    @complete = @atBat(@pitcher.pitchResult(@pitcher.pitch()))

  ballReceived: ->
    @balls + 1

  strikeReceived: (contact) ->
    unless contact is "foul" and @strikes is 2
      @strikes + 1

  walkOrStrikeOutCheck: ->
    if @balls is 4
      @complete = "walk"
    else if @strikes is 3
      @complete = "strikeout"
    else
      @complete = null
