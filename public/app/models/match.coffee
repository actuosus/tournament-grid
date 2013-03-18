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

    winnerChanged: (->
#      console.debug 'winnerChanged'
      stage = @get('round.stage')
#      console.debug stage
      console.debug @get 'itemIndex'
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
      stage = @get 'round.stage'
      stage.getByPath(@get 'parentNodePath') if stage
    ).property('parentNodePath')
    childNodes: null

    left: (->
      stage = @get 'round.stage'
      stage.getByPath(@get 'leftPath') if stage
    ).property('leftPath')

    right: (->
      stage = @get 'round.stage'
      stage.getByPath(@get 'rightPath') if stage
    ).property('rightPath')

#    future #default
#    current
#    delayed
#    closed

    longDateString: (-> moment(@get 'date').format('LLLL')).property 'date'

  App.Match.toString = -> 'Match'