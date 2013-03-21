###
 * match
 * @author: actuosus
 * @fileOverview Match model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ->
  App.Match = DS.Model.extend
#    init: ->
#      @_super()
#
#      DS.StateManager.prototype.states.rootState.states.loaded.states.created.states.locked = DS.State.create
#        enter: (manager)-> console.log arguments
#
#      stateManager = DS.StateManager.create record: @
#      @.set 'stateManager', stateManager
#
#      @._setup()
#
#      stateManager.goToState 'empty'

    isLocked: no
    isSelected: no

    primaryKey: '_id'
    name: DS.attr 'string'
    description: DS.attr 'string'
    date: DS.attr 'date'
    map_type: DS.attr 'string'
    type: DS.attr 'string'
    status: DS.attr 'string'

    entrants: (->
      isWinner = @get 'isWinner'
      if isWinner
        [@get('entrant1')]
      else
        [@get('entrant1'), @get('entrant2')]
    ).property().volatile()

    entrant1: DS.belongsTo 'App.Team'
    entrant2: DS.belongsTo 'App.Team'

    entrant1_points: DS.attr 'number'
    entrant2_points: DS.attr 'number'

    entrant1_race_id: DS.attr 'number'
    entrant2_race_id: DS.attr 'number'

    round: DS.belongsTo 'App.Round'

    games: DS.hasMany 'App.Game'

    entrant1Changed: (->
#      console.debug 'entrant1Changed'
      @set 'entrants', [@get('entrant1'), @get('entrant2')]
    ).observes 'entrant1'

    entrant2Changed: (->
#      console.debug 'entrant2Changed'
      @set 'entrants', [@get('entrant1'), @get('entrant2')]
    ).observes 'entrant2'

    resolveBrackets: ->
      matchIndex = @get 'itemIndex'
      stage = @get('round.stage')
      if stage
        roundIndex = @get 'round.itemIndex'
        brakets = stage.get 'brackets'

        loserBracket = brakets.findProperty('name', 'Losers')

        unless loserBracket
          loserBracket = brakets.createRecord
            itemIndex: 1
            name: 'Losers'

        rounds = loserBracket.get 'rounds'

        round = rounds.findProperty('itemIndex', roundIndex + 1)

        unless round
          round = rounds.createRecord
            itemIndex: roundIndex

        matches = round.get('matches')
        loser = @get 'loser'
        if loser
          if roundIndex is stage.get('rounds.length')-1
            itemIndex = Math.floor(matchIndex/2)
          else
            itemIndex = matchIndex
          match = matches.findProperty('itemIndex', itemIndex)
          unless match
            data = {itemIndex: itemIndex, isLocked: yes}
            data["entrant#{Math.floor(matchIndex%2)+1}"] = loser
            match = matches.createRecord data
          else
            match.get('entrants').replace Math.floor(matchIndex%2), 1, [loser]
            match.set "entrant#{Math.floor(matchIndex%2)+1}", loser

    winnerChanged: (->
#      console.debug 'winnerChanged'
      nextMatch = @get 'parentNode'
      winner = @get 'winner'
      matchIndex = @get 'itemIndex'
      if nextMatch
        if winner
          nextMatch.get('entrants').replace matchIndex%2, 1, [winner]
          nextMatch.set "entrant#{matchIndex%2+1}", winner
        else
          nextMatch.get('entrants').replace matchIndex%2, 1, [null]
          nextMatch.set "entrant#{matchIndex%2+1}", null

#      stage.checkRounds('winners') if stage
#      @resolveBrackets()
    ).observes('winner')

    loser: (->
      if @get('entrant1_points') > @get('entrant2_points')
#        loser = @get 'entrant1'
        loser = @get('entrants')[1]
      else if @get('entrant1_points') < @get('entrant2_points')
#        loser = @get 'entrant2'
        loser = @get('entrants')[0]
      else
        loser = undefined
      return loser
    ).property 'entrants', 'entrant1_points', 'entrant2_points'

    winner: (->
      if @get('entrant1_points') > @get('entrant2_points')
#        winner = @get 'entrant1'
        winner = @get('entrants')[0]
      else if @get('entrant1_points') < @get('entrant2_points')
#        winner = @get 'entrant2'
        winner = @get('entrants')[1]
      else
        winner = undefined
      return winner
    ).property 'entrants', 'entrant1_points', 'entrant2_points'

    parent: (-> @get 'round').property('round')
    children: (-> @get 'entrants').property('entrants')

    parentNode: (->
      parent = @get 'round.parent'
      parent.getByPath(@get 'parentNodePath') if parent
    ).property('parentNodePath')
    childNodes: null

    left: (->
      parent = @get 'round.parent'
      parent.getByPath(@get 'leftPath') if parent
    ).property('leftPath')

    right: (->
      parent = @get 'round.parent'
      parent.getByPath(@get 'rightPath') if parent
    ).property('rightPath')

#    future #default
#    current
#    delayed
#    closed

    longDateString: (-> moment(@get 'date').format('LLLL')).property 'date'

  App.Match.toString = -> 'Match'