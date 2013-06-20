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
    sortIndex: DS.attr 'number'
    entrant1: DS.belongsTo 'App.Team'
    entrant2: DS.belongsTo 'App.Team'
    entrant1_points: DS.attr 'number'
    entrant2_points: DS.attr 'number'

    entrant1_race_id: DS.attr 'number'
    entrant2_race_id: DS.attr 'number'

#    editingStatus: DS.attr 'string'

    # Relations
    round: DS.belongsTo 'App.Round'
    stage: DS.belongsTo 'App.Stage'
    games: DS.hasMany('App.Game', {inverse: 'match'})

    hasPoints: (->
      not Em.isEmpty(@get('entrant1_points')) and not Em.isEmpty(@get('entrant2_points'))
    ).property('entrant1_points', 'entrant2_points')

    link: (-> "/matches/#{@get 'id'}" ).property('url')

    currentStatus: (->
      status = @get 'status'
      date = @get 'date'
      entrant1_points = @get 'entrant1_points'
      entrant2_points = @get 'entrant2_points'
      reopenInterval = 1000 * 60 * 60 * 12
      currentDate = new Date
      if date < currentDate
        currentStatus = 'past'
      if date < currentDate and (entrant1_points and entrant2_points) and status isnt 'closed'
        currentStatus = 'active'
      if date > (currentDate + reopenInterval) and (entrant1_points and entrant2_points)
        currentStatus = 'delayed'
      if (not date or date > currentDate) or not (entrant1_points and entrant2_points)
        currentStatus = 'future'
      currentStatus
    ).property('date', 'entrant1_points', 'entrant2_points')

    open: ->
      @set 'status', 'opened'
      @store.commit()

    close: ->
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
    ).property('entrant1', 'entrant2')

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
        winner = @get('entrants')[0]
      else if @get('entrant1_points') < @get('entrant2_points')
        winner = @get('entrants')[1]
      else
        winner = undefined
      return winner
    ).property 'entrants', 'entrant1_points', 'entrant2_points'

    # TODO Kind of hacky, should refine.
    firstIsAWinner: (-> Em.isEqual(@get('entrant1'), @get('winner'))).property('winner')
    firstIsALoser: (-> Em.isEqual(@get('entrant1'), @get('loser'))).property('loser')

    secondIsAWinner: (-> Em.isEqual(@get('entrant2'), @get('winner'))).property('winner')
    secondIsALoser: (-> Em.isEqual(@get('entrant2'), @get('loser'))).property('loser')

    parentNode: (->
      parent = @get 'round.parent'
      parentNodePath = @get 'parentNodePath'
      if parentNodePath
        return parent.getByPath(parentNodePath) if parent
      else
        if parent
          round = @get 'round'
          roundIndex = parent.get('rounds').indexOf(round)
          matchIndex = round.get('matches').indexOf(@)
          parentNodePath = "#{roundIndex+1}.#{Math.floor(matchIndex/2)}"
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

  # Ember History
  #    _trackProperties: [
  #      'entrant1_points'
  #      'entrant2_points'
  #      'date'
  #    ]


  App.Match.toString = -> 'Match'