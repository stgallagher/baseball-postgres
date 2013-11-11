#= require contact

describe "Contact", ->

  beforeEach ->
    pb = new Probabilities(3, 3, 3)
    @ct = new Contact(pb)

  it "contact results in a one of a set of contact results", ->
    contacts = [1..100]
    for contact in contacts
      result = @ct.contactReceived(contact)
      #console.log("contact = #{contact} -> result = #{result}")
      expect(["foul", "single", "double", "triple", "homerun", "pop fly out", "ground ball out"]).toContain(result)

