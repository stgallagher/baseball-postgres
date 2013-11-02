#= require team

describe "Team", ->
  tm = null

  beforeEach ->
    tm = new Team("Wildcats")
    player1 = { name: "Dave" }
    player2 = { name: "Bob" }
    player3 = { name: "Larry" }
    player4 = { name: "Joe" }
    tm.players = [player1, player2, player3, player4]

  it "team name isn't blank", ->
    expect(tm.name).not.toBe(null)

  it "has players", ->
    expect(tm.players).not.toBe(null)

  it "#nextBatter: gets the next batter", ->
    batter = tm.nextBatter()
    expect(batter.name).toEqual("Bob")

  it "#nextBatter: returns to the first batter if called on the last", ->
    tm.currentPlayerIndex = 3
    batter = tm.nextBatter()
    expect(batter.name).toEqual("Dave")
