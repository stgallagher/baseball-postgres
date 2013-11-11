#= require pitching

describe "Pitching", ->
  pt = null

  beforeEach ->
    pb = new Probabilities(null, 3, 3)
    pt = new Pitching(pb)

  it "returns ball if the pitch is in the ball range", ->
    expect(pt.pitchResult(15)).toBe("ball")

  it "returns strike if the pitch is in the strike range", ->
    expect(pt.pitchResult(40)).toBe("strike")

  it "returns contact if the pitch is in the contact range", ->
    expect(pt.pitchResult(85)).toBe("contact")

  it "pitch results in a strike, ball, or contact", ->
    pitches = [1..100]
    for pitch in pitches
      result = pt.pitchResult(pitch)
      #console.log("pitch = #{pitch} -> result = #{result}")
      expect(["ball", "strike", "contact"]).toContain(result)
