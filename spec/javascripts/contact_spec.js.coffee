#= require contact

describe "Contact", ->
  ct = null

  beforeEach ->
    ct = new Contact()

  it "contact results in a one of a set of contact results", ->
    contacts = [1..100]
    for contact in contacts
      result = ct.contactReceived(contact)
      #console.log("contact = #{contact} -> result = #{result}")
      expect(["foul", "single", "double", "triple", "home run", "pop fly out", "ground ball out"]).toContain(result)

