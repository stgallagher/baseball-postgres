class @BaseRunners

  updateBaseOccupancy: (baseOccupancy, result) ->
    baseRunners = _.pick(baseOccupancy, 'first', 'second', 'third')

    if _.isEqual(baseRunners, BASE_RUNNERS.basesLoaded)
        baseOccupancy = AT_BAT_RESULTS[result].basesLoaded
    else if _.isEqual(baseRunners, BASE_RUNNERS.firstAndSecond)
        baseOccupancy = AT_BAT_RESULTS[result].firstAndSecond
    else if _.isEqual(baseRunners, BASE_RUNNERS.secondAndThird)
        baseOccupancy = AT_BAT_RESULTS[result].secondAndThird
    else if _.isEqual(baseRunners, BASE_RUNNERS.firstAndThird)
        baseOccupancy = AT_BAT_RESULTS[result].firstAndThird
    else if _.isEqual(baseRunners, BASE_RUNNERS.first)
        baseOccupancy = AT_BAT_RESULTS[result].first
    else if _.isEqual(baseRunners, BASE_RUNNERS.second)
        baseOccupancy = AT_BAT_RESULTS[result].second
    else if _.isEqual(baseRunners, BASE_RUNNERS.third)
        baseOccupancy = AT_BAT_RESULTS[result].third

    return { bases: baseOccupancy, addedScore: baseOccupancy.addedScore }

  BASE_RUNNERS =
      basesLoaded:    first: "manned", second: "manned", third: "manned"
      firstAndSecond: first: "manned", second: "manned", third: "empty"
      firstAndThird:  first: "manned", second: "empty",  third: "manned"
      secondAndThird: first: "empty",  second: "manned", third: "manned"
      first:          first: "manned", second: "empty",  third: "empty"
      second:         first: "empty",  second: "manned", third: "empty"
      third:          first: "empty",  second: "empty",  third: "manned"
      empty:          first: "empty",  second: "empty",  third: "empty"

  WALK_AT_BAT_RESULT =
      basesLoaded:    first: "manned",  second: "manned", third: "manned",  addedScore: 1
      firstAndSecond: first: "manned",  second: "manned", third: "manned",  addedScore: 0
      firstAndThird:  first: "manned",  second: "manned", third: "manned",  addedScore: 0
      secondAndThird: first: "manned",  second: "manned", third: "manned",  addedScore: 0
      first:          first: "manned",  second: "manned", third: "empty",   addedScore: 0
      second:         first: "manned",  second: "manned", third: "empty",   addedScore: 0
      third:          first: "manned",  second: "empty",  third: "manned",  addedScore: 0
      empty:          first: "manned",  second: "empty",  third: "empty",   addedScore: 0

  SINGLE_AT_BAT_RESULT =
      basesLoaded:    first: "manned",  second: "manned", third: "manned",  addedScore: 1
      firstAndSecond: first: "manned",  second: "manned", third: "manned",  addedScore: 0
      firstAndThird:  first: "manned",  second: "empty",  third: "empty",   addedScore: 1
      secondAndThird: first: "manned",  second: "empty",  third: "manned",  addedScore: 1
      first:          first: "manned",  second: "manned", third: "empty",   addedScore: 0
      second:         first: "manned",  second: "empty",  third: "manned",  addedScore: 0
      third:          first: "manned",  second: "empty",  third: "empty",   addedScore: 1
      empty:          first: "manned",  second: "empty",  third: "empty",   addedScore: 0

  DOUBLE_AT_BAT_RESULT =
      basesLoaded:    first: "empty",  second: "manned", third: "manned",  addedScore: 2
      firstAndSecond: first: "empty",  second: "manned", third: "manned",  addedScore: 1
      firstAndThird:  first: "empty",  second: "manned", third: "manned",  addedScore: 1
      secondAndThird: first: "empty",  second: "manned", third: "empty",   addedScore: 2
      first:          first: "empty",  second: "manned", third: "manned",  addedScore: 0
      second:         first: "empty",  second: "manned", third: "empty",   addedScore: 1
      third:          first: "empty",  second: "manned", third: "empty",   addedScore: 1
      empty:          first: "empty",  second: "manned", third: "empty",   addedScore: 0

  TRIPLE_AT_BAT_RESULT =
      basesLoaded:    first: "empty",  second: "empty", third: "manned",  addedScore: 3
      firstAndSecond: first: "empty",  second: "empty", third: "manned",  addedScore: 2
      firstAndThird:  first: "empty",  second: "empty", third: "manned",  addedScore: 2
      secondAndThird: first: "empty",  second: "empty", third: "manned",  addedScore: 2
      first:          first: "empty",  second: "empty", third: "manned",  addedScore: 1
      second:         first: "empty",  second: "empty", third: "manned",  addedScore: 1
      third:          first: "empty",  second: "empty", third: "manned",  addedScore: 1
      empty:          first: "empty",  second: "empty", third: "manned",  addedScore: 0

  HOME_RUN_AT_BAT_RESULT =
      basesLoaded:    first: "empty",  second: "empty", third: "empty",  addedScore: 4
      firstAndSecond: first: "empty",  second: "empty", third: "empty",  addedScore: 3
      firstAndThird:  first: "empty",  second: "empty", third: "empty",  addedScore: 3
      secondAndThird: first: "empty",  second: "empty", third: "empty",  addedScore: 3
      first:          first: "empty",  second: "empty", third: "empty",  addedScore: 2
      second:         first: "empty",  second: "empty", third: "empty",  addedScore: 2
      third:          first: "empty",  second: "empty", third: "empty",  addedScore: 2
      empty:          first: "empty",  second: "empty", third: "empty",  addedScore: 1

  AT_BAT_RESULTS =
      walk:     WALK_AT_BAT_RESULT,
      single:   SINGLE_AT_BAT_RESULT,
      double:   DOUBLE_AT_BAT_RESULT,
      triple:   TRIPLE_AT_BAT_RESULT,
      homerun:  HOME_RUN_AT_BAT_RESULT


