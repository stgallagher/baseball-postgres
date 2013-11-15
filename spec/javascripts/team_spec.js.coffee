#= require team

describe "Team", ->
  tm = null

  beforeEach ->
    tm = new Team()
    player1 = { name: "Dave",   position: "C"  }
    player2 = { name: "Bob",    position: "LF"  }
    player3 = { name: "Larry",  position: "P" }
    player4 = { name: "Joe",    position: "1B"  }
    tm.players = [player1, player2, player3, player4]

  it "has players", ->
    expect(tm.players).not.toBe(null)

  it "#nextBatter: gets the next batter", ->
    batter = tm.nextBatter()
    expect(batter.name).toEqual("Bob")

  it "#nextBatter: returns to the first batter if called on the last", ->
    tm.currentPlayerIndex = 3
    batter = tm.nextBatter()
    expect(batter.name).toEqual("Dave")

  it "#pitcher: returns pitcher", ->
    pitcher = tm.pitcher()
    console.log "IN TEAM_SPEC::pitcher -> #{JSON.stringify(tm.pitcher())}"
    expect(pitcher.name).toEqual("Larry")
