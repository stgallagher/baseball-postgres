#= require game_engine

describe "GameEngine", ->
  ge = null

  beforeEach ->
    ge = new GameEngine()

  it "ball recieved adds one to the ball count", ->
    expect(ge.ballReceived(2)).toBe(3)

  it "strike recieved adds one to the ball count", ->
    expect(ge.strikeReceived(null, 1)).toBe(2)

  it "strike recieved does not add a strike if the contact result was a foul", ->
    expect(ge.strikeReceived("foul", 2)).toBe(2)
