class @Player
  constructor: ->
    @name = Faker.Name.lastName() + " " + Faker.Name.lastName()
