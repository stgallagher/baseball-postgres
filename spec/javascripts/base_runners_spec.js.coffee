#= require base_runners

describe "BaseRunners", ->
  br = null

  beforeEach ->
    br = new BaseRunners()

  it "homerun with bases loaded", ->
    bases = { first: "manned", second: "manned", third: "manned" }
    result = "homerun"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "empty", second: "empty", third: "empty", addedScore: 4 })

  it "homerun with man on second", ->
    bases = { first: "empty", second: "manned", third: "empty" }
    result = "homerun"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "empty", second: "empty", third: "empty", addedScore: 2  })

  it "single with man on third", ->
    bases = { first: "empty", second: "empty", third: "manned" }
    result = "single"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "manned", second: "empty", third: "empty", addedScore: 1  })

  it "single with man on first and second", ->
    bases = { first: "manned", second: "manned", third: "empty" }
    result = "single"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "manned", second: "manned", third: "manned", addedScore: 0  })

  it "double with man on second", ->
    bases = { first: "empty", second: "manned", third: "empty" }
    result = "double"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "empty", second: "manned", third: "empty", addedScore: 1 })

  it "double with man on first", ->
    bases = { first: "manned", second: "empty", third: "empty" }
    result = "double"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "empty", second: "manned", third: "manned", addedScore: 0 })

  it "triple with man on second and third", ->
    bases = { first: "empty", second: "manned", third: "manned" }
    result = "triple"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "empty", second: "empty", third: "manned", addedScore: 2 })

  it "triple hit with man on first", ->
    bases = { first: "manned", second: "empty", third: "empty" }
    result = "triple"
    outcome = br.updateBaseOccupancy(bases, result)
    expect(outcome.bases).toEqual({ first: "empty", second: "empty", third: "manned", addedScore: 1 })

  # --- End updateBaseOccupancy scenarios

  it "walks act like singles", ->
    bases = { first: "manned", second: "empty", third: "manned" }
    outcome = br.updateBaseOccupancy(bases, "walk")
    expect(outcome.bases).toEqual({ first: "manned", second: "manned", third: "manned", addedScore: 0})
