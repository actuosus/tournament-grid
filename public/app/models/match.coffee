###
 * match
 * @author: actuosus
 * @fileOverview Match model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core'],->
  App.Match = DS.Model.extend
    primaryKey: '_id'

    title: DS.attr 'string'
    description: DS.attr 'string'
    date: DS.attr 'date'
    url: DS.attr 'string'
    map_type: DS.attr 'string'
    status: DS.attr 'string', {defaultValue: 'opened'}
    type: DS.attr 'string'
    sort_index: DS.attr 'number'
    entrant1: DS.belongsTo 'App.Team'
    entrant2: DS.belongsTo 'App.Team'
    entrant1_points: DS.attr 'number'
    entrant2_points: DS.attr 'number'

    entrant1_race_id: DS.attr 'number'
    entrant2_race_id: DS.attr 'number'
    editingStatus: DS.attr 'string'

    # Relations
    round: DS.belongsTo 'App.Round'
    stage: DS.belongsTo 'App.Stage'

    games: DS.hasMany('App.Game', {inverse: 'match'})

    # Ember History
#    _trackProperties: [
#      'entrant1_points'
#      'entrant2_points'
#      'date'
#    ]

    link: (->
      "/matches/#{@get 'id'}"
    ).property('url')

    currentStatus: (->
      status = @get 'status'
      date = @get 'date'
      entrant1_points = @get 'entrant1_points'
      entrant2_points = @get 'entrant2_points'
      reopenInterval = 1000 * 60 * 60 * 12
      currentDate = new Date
      console.log 'currentStatus', date < currentDate
      if date < currentDate
        currentStatus = 'past'
      if date < currentDate and (entrant1_points and entrant2_points) and status isnt 'closed'
        currentStatus = 'active'
      if date > (currentDate + reopenInterval) and (entrant1_points and entrant2_points)
        currentStatus = 'delayed'
      if not (date or date > currentDate) and not (entrant1_points and entrant2_points)
        currentStatus = 'future'
      currentStatus
    ).property('date', 'entrant1_points', 'entrant2_points')

    isOpenable: (->
      currentStatus = @get 'currentStatus'
      date = @get 'date'
      currentDate = new Date
      reopenInterval = 1000 * 60 * 60 * 12
      currentStatus is 'active' and ((date + reopenInterval) > currentDate)
    ).property('currentStatus', 'date').volatile()

    open: ->
      console.log 'Opening match'
      @set 'status', 'opened'
      @store.commit()

    close: ->
      console.log 'Closing match'
      @set 'status', 'closed'
      @store.commit()

    isPast: (->
      new Date > @get 'date'
    ).property('date')

    # Match is only valid if it has entrants.
    valid: (->
      valid = no
      if @get('entrant1') and @get('entrant2')
        valid = yes
      valid
    ).property('entrant1', 'entrant2')

    invalid: Em.computed.not 'valid'

    isSelected: no

    entrants: (->
      isWinner = @get 'isWinner'
      if isWinner
        [@get('entrant1')]
      else
        [@get('entrant1'), @get('entrant2')]
    ).property().volatile()

    entrant1Changed: (->
      isWinner = @get 'isWinner'
      if isWinner
        @set 'entrants', [@get('entrant1')]
      else
        @set 'entrants', [@get('entrant1'), @get('entrant2')]
    ).observes 'entrant1'

    entrant2Changed: (->
      isWinner = @get 'isWinner'
      if isWinner
        @set 'entrants', [@get('entrant1')]
      else
        @set 'entrants', [@get('entrant1'), @get('entrant2')]
    ).observes 'entrant2'

    winnerChanged: (->
#      console.debug 'winnerChanged'
      nextMatch = @get 'parentNode'
      winner = @get 'winner'
      matchIndex = @get 'itemIndex'
      unless matchIndex
        round = @get 'round'
        if round
          matches = round.get('matches')
          if matches
            matchIndex = matches.indexOf(@)
      if nextMatch
        if winner
          nextMatch.get('entrants').replace matchIndex%2, 1, [winner]
          nextMatch.set "entrant#{matchIndex%2+1}", winner
        else
          nextMatch.get('entrants').replace matchIndex%2, 1, [null]
          nextMatch.set "entrant#{matchIndex%2+1}", null
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

    treeItemChildren: (-> @get 'entrants').property('entrants')

    parentNode: (->
      parent = @get 'round.parent'
      parentNodePath = @get 'parentNodePath'
      if parentNodePath
        return parent.getByPath(parentNodePath) if parent
      else
        if parent
          round = @get 'round'
          roundIndex = parent.get('rounds').indexOf(round)
          roundsCount = parent.get('rounds.length')-1
          matchIndex = round.get('matches').indexOf(@)
          parentNodePath = "#{roundIndex+1}.#{Math.floor(matchIndex/2)}"
          console.log 'parentNodePath', parentNodePath
          @set 'parentNodePath', parentNodePath
          return parent.getByPath(parentNodePath)
    ).property('parentNodePath').volatile()
    childNodes: null

    left: (->
      parent = @get 'round.parent'
      leftPath = @get 'leftPath'
      if leftPath
        return parent.getByPath(leftPath) if parent
      else
        if parent
          round = @get 'round'
          roundIndex = parent.get('rounds').indexOf(round)
          roundsCount = parent.get('rounds.length')
          matchIndex = round.get('matches').indexOf(@)
          leftPath = "#{roundsCount-roundIndex-1}.#{matchIndex*2}"
          @set 'leftPath', leftPath
          return parent.getByPath(leftPath)
    ).property('leftPath')

    right: (->
      parent = @get 'round.parent'
      rightPath = @get 'rightPath'
      if rightPath
        return parent.getByPath(rightPath) if parent
      else
        if parent
          round = @get 'round'
          roundIndex = parent.get('rounds').indexOf(round)
          roundsCount = parent.get('rounds.length')
          matchIndex = round.get('matches').indexOf(@)
          rigthPath = "#{roundsCount-roundIndex-1}.#{matchIndex+1}"
          @set 'rigthPath', rigthPath
          return parent.getByPath(rigthPath)
    ).property('rightPath')

  App.Match.toString = -> 'Match'