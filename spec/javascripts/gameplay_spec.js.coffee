#= require gameplay

describe "Gameplay", ->

  it "returns ball if the pitch is in the ball range", ->
    expect(new Gameplay().pitchResult(25)).toBe("ball")

  it "returns strike if the pitch is in the strike range", ->
    expect(new Gameplay().pitchResult(65)).toBe("strike")

  it "returns contact if the pitch is in the contact range", ->
    expect(new Gameplay().pitchResult(95)).toBe("contact")

  it "pitch results in a strike, ball, or contact", ->
    result = new Gameplay().pitchResult(new Gameplay().pitch())
    expect(["ball", "strike", "contact"]).toContain(result)

  it "contact results in a one of a set of contact results", ->
    result = new Gameplay().contactResult(new Gameplay().contact())
    expect(["foul", "single", "double", "triple", "home run", "pop fly out", "ground ball out"]).toContain(result)
