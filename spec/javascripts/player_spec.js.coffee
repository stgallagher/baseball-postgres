#= require player

describe "Player", ->
  pr = null

  beforeEach ->
    pr = new Player()

  it "player has a name", ->
    expect(pr.name).not.toBe(null)
