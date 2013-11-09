#= require at_bat

describe "AtBat", ->

  beforeEach ->
    p = new Pitching()
    c = new Contact()
    br = new BaseRunners()
    d = new GameDisplay()
    @ab = new AtBat(p, c, br, d)

  it "#ballReceived increments ball count", ->
    @ab.ballReceived()
    expect(@ab.balls).toEqual(1)

  it "strike recieved adds one to the strikes count", ->
    @ab.strikeReceived()
    expect(@ab.strikes).toEqual(1)

  it "strike recieved does not add a strike if the contact result was a foul", ->
    @ab.strikes = 2
    @ab.strikeReceived("foul")
    expect(@ab.strikes).toEqual(2)

  it "#atBat: if contact is ball, balls increments, atbat is not complete", ->
    @ab.atbat("ball")
    expect(@ab.balls).toEqual(1)
    expect(@ab.complete).toEqual(null)

  it "#atBat: if contact is strike, strikes increments, atbat is not complete", ->
    @ab.atbat("strike")
    expect(@ab.strikes).toEqual(1)
    expect(@ab.complete).toEqual(null)


  it "#batterMadeContact: if contact is a strikeout, batter is out, atbat is complete", ->
    @ab.batterMadeContact("strikeout")
    expect(@ab.isOut).toEqual(true)
    expect(@ab.complete).toEqual("Strikeout")

  it "#batterMadeContact: if contact is single, bases are updated", ->
    @ab.baseOccupancy = { first: "manned", second: "manned", third: "manned" }
    @ab.batterMadeContact("single")
    expect(@ab.baseOccupancy).toEqual( { first: "manned", second: "manned", third: "manned", addedScore: 1 })

  it "#batterMadeContact: if contact is double, bases are updated", ->
    @ab.baseOccupancy = { first: "manned", second: "empty", third: "manned" }
    @ab.batterMadeContact("double")
    expect(@ab.baseOccupancy).toEqual( { first: "empty", second: "manned", third: "manned", addedScore: 1 })

  it "#batterMadeContact: if contact is triple, bases are updated", ->
    @ab.baseOccupancy = { first: "manned", second: "empty", third: "empty" }
    @ab.batterMadeContact("triple")
    expect(@ab.baseOccupancy).toEqual( { first: "empty", second: "empty", third: "manned", addedScore: 1 })

  it "#batterMadeContact: if contact is homerun, bases are updated", ->
    @ab.baseOccupancy = { first: "empty", second: "manned", third: "manned" }
    @ab.batterMadeContact("homerun")
    expect(@ab.baseOccupancy).toEqual( { first: "empty", second: "empty", third: "empty", addedScore: 3 })

  it "#walkOrStrikeOutCheck: if ball scount is 4, indicates walk", ->
    @ab.walkOrStrikeOutCheck()
    expect(@ab.complete).toEqual(null)
    @ab.balls = 4
    @ab.walkOrStrikeOutCheck()
    expect(@ab.complete).toEqual("Walk")
