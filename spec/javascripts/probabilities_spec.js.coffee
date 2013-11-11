#= require probabilities

describe "Probabilities", ->

  beforeEach ->

  it "#determinePitchLevel -1- returns correct output for given input", ->
    pb = new Probabilities(null, 3, 3)
    expect(pb.determinePitchLevel()).toEqual(5)

  it "#determinePitchLevel -2- returns correct output for given input", ->
    pb = new Probabilities(null, 1, 5)
    expect(pb.determinePitchLevel()).toEqual(9)

  it "#determinePitchLevel -3- returns correct output for given input", ->
    pb = new Probabilities(null, 5, 1)
    expect(pb.determinePitchLevel()).toEqual(1)

  it "#determinePitchLevel -4- returns correct output for given input", ->
    pb = new Probabilities(null, 4, 2)
    expect(pb.determinePitchLevel()).toEqual(3)

  it "#determinePitchLevel -5- returns correct output for given input", ->
    pb = new Probabilities(null, 2, 4)
    expect(pb.determinePitchLevel()).toEqual(7)
