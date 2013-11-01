#= require team

describe "Team", ->
  tm = null

  beforeEach ->
    tm = new Team("Wildcats")

  it "team name isn't blank", ->
    expect(tm.name).not.toBe(null)

  it "has players", ->
    expect(tm.players).not.toBe(null)

