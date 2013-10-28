#= require gameplay

describe "Gameplay", ->
  gp = null

  beforeEach ->
    gp = new Gameplay()

  it "returns ball if the pitch is in the ball range", ->
    expect(gp.pitchResult(25)).toBe("ball")

  it "returns strike if the pitch is in the strike range", ->
    expect(gp.pitchResult(65)).toBe("strike")

  it "returns contact if the pitch is in the contact range", ->
    expect(gp.pitchResult(95)).toBe("contact")

  it "pitch results in a strike, ball, or contact", ->
    pitches = [1..100]
    for pitch in pitches
      result = gp.pitchResult(pitch)
      #console.log("pitch = #{pitch} -> result = #{result}")
      expect(["ball", "strike", "contact"]).toContain(result)

  it "contact results in a one of a set of contact results", ->
    contacts = [1..100]
    for contact in contacts
      result = gp.contactReceived(contact)
      #console.log("contact = #{contact} -> result = #{result}")
      expect(["foul", "single", "double", "triple", "home run", "pop fly out", "ground ball out"]).toContain(result)

  it "ball recieved adds one to the ball count", ->
    expect(gp.ballReceived(2)).toBe(3)

  it "strike recieved adds one to the ball count", ->
    expect(gp.strikeReceived(null, 1)).toBe(2)

  it "strike recieved does not add a strike if the contact result was a foul", ->
    expect(gp.strikeReceived("foul", 2)).toBe(2)

  # updateBaseOccupancy scenarios
  it "homerun with bases loaded", ->
    bases = { first: "manned", second: "manned", third: "manned" }
    score = 0
    result = "home run"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(4)
    expect(bases).toEqual({ first: "empty", second: "empty", third: "empty" })

  it "homerun with man on second", ->
    bases = { first: "empty", second: "manned", third: "empty" }
    score = 0
    result = "home run"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(2)
    expect(bases).toEqual({ first: "empty", second: "empty", third: "empty" })

  it "single with man on third", ->
    bases = { first: "empty", second: "empty", third: "manned" }
    score = 0
    result = "single"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(1)
    expect(bases).toEqual({ first: "manned", second: "empty", third: "empty" })

  it "single with man on first and second", ->
    bases = { first: "manned", second: "manned", third: "empty" }
    score = 0
    result = "single"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(0)
    expect(bases).toEqual({ first: "manned", second: "manned", third: "manned" })

  it "double with man on second", ->
    bases = { first: "empty", second: "manned", third: "empty" }
    score = 0
    result = "double"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(1)
    expect(bases).toEqual({ first: "empty", second: "manned", third: "empty" })

  it "double with man on first", ->
    bases = { first: "manned", second: "empty", third: "empty" }
    score = 0
    result = "double"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(0)
    expect(bases).toEqual({ first: "empty", second: "manned", third: "manned" })

  it "triple with man on second and third", ->
    bases = { first: "empty", second: "manned", third: "manned" }
    score = 0
    result = "triple"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(2)
    expect(bases).toEqual({ first: "empty", second: "empty", third: "manned" })

  it "triple hit with man on first", ->
    bases = { first: "manned", second: "empty", third: "empty" }
    score = 0
    result = "triple"
    expect(gp.updateBaseOccupancy(bases, result, score)).toBe(1)
    expect(bases).toEqual({ first: "empty", second: "empty", third: "manned" })

  # --- End updateBaseOccupancy scenarios

  it "walks act like singles", ->
    bases = { first: "manned", second: "empty", third: "manned" }
    score = 0
    expect(gp.updateBaseOccupancy(bases,'walk', score)).toBe(0)
    expect(bases).toEqual({ first: "manned", second: "manned", third: "manned" })

