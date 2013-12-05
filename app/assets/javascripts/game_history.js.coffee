class @GameHistory
  constructor: (@home, @away) ->
    @atBats = []

  recordAtBat: () ->
    atbat =
    batter    : @game.batter.name
    pitcher   : @game.pitcher.name
    balls     : @game.balls
    strikes   : @game.strikes
    rbi       : @game.addedScore
    result    : @game.result
    side      : @game.side
    inning    : @game.inning
    score     : @game.score

    @atBats.push atbat
    console.log "IN GAME_HISTORY::recordAtBat -> @atBats = #{JSON.stringify(@atBats)}"

