#= require base_runners

describe "BaseRunners", ->
  br = null

  beforeEach ->
    br = new BaseRunners()

  it "homerun with bases loaded", ->
    bases = { first: "manned", second: "manned", third: "manned" }
    result = "homerun"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "empty", second: "empty", third: "empty", addedScore: 4 })

  it "homerun with man on second", ->
    bases = { first: "empty", second: "manned", third: "empty" }
    result = "homerun"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "empty", second: "empty", third: "empty", addedScore: 2  })

  it "single with man on third", ->
    bases = { first: "empty", second: "empty", third: "manned" }
    result = "single"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "manned", second: "empty", third: "empty", addedScore: 1  })

  it "single with man on first and second", ->
    bases = { first: "manned", second: "manned", third: "empty" }
    result = "single"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "manned", second: "manned", third: "manned", addedScore: 0  })

  it "double with man on second", ->
    bases = { first: "empty", second: "manned", third: "empty" }
    result = "double"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "empty", second: "manned", third: "empty", addedScore: 1 })

  it "double with man on first", ->
    bases = { first: "manned", second: "empty", third: "empty" }
    result = "double"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "empty", second: "manned", third: "manned", addedScore: 0 })

  it "triple with man on second and third", ->
    bases = { first: "empty", second: "manned", third: "manned" }
    result = "triple"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "empty", second: "empty", third: "manned", addedScore: 2 })

  it "triple hit with man on first", ->
    bases = { first: "manned", second: "empty", third: "empty" }
    result = "triple"
    expect(br.updateBaseOccupancy(bases, result)).toEqual({ first: "empty", second: "empty", third: "manned", addedScore: 1 })

  # --- End updateBaseOccupancy scenarios

  it "walks act like singles", ->
    bases = { first: "manned", second: "empty", third: "manned" }
    expect(br.updateBaseOccupancy(bases, "walk")).toEqual({ first: "manned", second: "manned", third: "manned", addedScore: 0})
