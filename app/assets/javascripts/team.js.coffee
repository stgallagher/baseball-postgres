$(document).ready ->

  $("#team-button").on "click", ->
    console.log(gon.team)

class @Team
  constructor: (name) ->
    @name = name
    @players = @createPlayers()
    @currentPlayerIndex = 0

  createPlayers: ->
    players = []
    _(9).times ->  players.push new Player()
    players

  firstBatter: ->
    @players[0]

  nextBatter: ->
    if @createPlayers
      if @currentPlayerIndex + 1 is @players.length
        @currentPlayerIndex = 0
        return @players[@currentPlayerIndex]
      else
        return @players[@currentPlayerIndex += 1]


  getTeamInfo:(teamId) ->
    a = []
    #$.getJSON "http://localhost:4000/teams/3", { team: 3 }, (data) ->
    #  _.each(data.players, (value) ->
    #      a.push(_.pick(value, 'name'))
    #  )
    #  console.log "data = #{JSON.stringify(a)}"

    request = $.ajax
       dataType: 'json',
       url: "http://localhost:4000/teams/#{teamId}",
       async: false
       #(data) ->
       #  console.log "IN AJAX -> data = #{data}"
       #  _.each(data.players, (value) ->
       #      console.log "IN AJAX -> value = #{value}"
       #      a.push(_.pick(value, 'name'))
       #  )
      .done (msg) ->
        _.each(msg.players, (value) ->
            a.push(_.pick(value, 'name')))

    console.log "THIS IS a = #{JSON.stringify(a)}"
    a
