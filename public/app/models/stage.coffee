###
 * stage
 * @author: actuosus
 * @fileOverview Stage model.
 * Date: 06/02/2013
 * Time: 03:06
###

define ['cs!../core'],->
  App.Stage = DS.Model.extend
    primaryKey: '_id'

    title: DS.attr('string', {loc: {keyPath: '_title', defaultLanguage: 'ru'}})

    # TODO Translation.
#    __title: ((a,b,c,d)->
#      nameHash = @get '_name'
#      currentLanguage = App.get('currentLanguage')
#      value = ''
#      if currentLanguage and nameHash
#        value = nameHash[currentLanguage]
#      unless value
#        value = @get 'name'
#      value
#    ).property('_name', 'App.currentLanguage')

#    _title: DS.attr('object')

    description: DS.attr 'string'
    visualType: DS.attr 'string'
    sortIndex: DS.attr 'number'

    isSingleElimination: yes

    parent: (-> @get 'report').property('report')
    children: (-> @get 'rounds').property('rounds')

    treeItemChildren: (-> @get 'rounds').property('rounds')

    left: null
    right: null

    report: DS.belongsTo 'App.Report'

    rounds: DS.hasMany 'App.Round'
    brackets: DS.hasMany 'App.Bracket'

    rating: DS.attr 'number'

    entrantsNumber: DS.attr 'number'

    _rounds: (->
      rounds = @get 'rounds'
      finalRound = rounds.createRecord
        itemIndex: -1
        parentReference: 'stage'
      finalRound.get('matches').createRecord
        isWinner: yes
        isFinal: yes
        itemIndex: -1
      Em.ArrayController.create content: rounds
    ).property('rounds')

    getDescendant: (child, idx)-> child.get('children').objectAt idx if child

    getByPath: (path, root = @)->
      if path
        splittedPath = path.split '.'
        lastChild = @getDescendant root, splittedPath[0]
        for idx in [1...splittedPath.length]
          lastChild = @getDescendant lastChild, splittedPath[idx]
        lastChild

    selectByPath: (startRoundIndex, startMatchIndex)->
      rounds = @get 'rounds'
      roundsLength = rounds.get('length')
      Em.beginPropertyChanges()
      for roundIndex in [startRoundIndex...roundsLength]
        round = rounds.objectAt roundIndex
        matchIndexToSelect = Math.floor(startMatchIndex / Math.pow(2, roundIndex))
        match = round.get('matches').objectAt(matchIndexToSelect)
        match.set('isSelected', yes) if match
      Em.endPropertyChanges()

    deselectByPath: (startMatchIndex)->
      rounds = @get 'rounds'
      Em.beginPropertyChanges()
      rounds.forEach (round, roundIndex)->
        matchIndexToSelect = Math.floor(startMatchIndex / Math.pow(2, roundIndex))
        match = round.get('matches').objectAt(matchIndexToSelect)
        match.set('isSelected', no) if match
      Em.endPropertyChanges()

    entrants: (->
      entrants = []
      rounds = @get 'rounds'
      rounds.forEach (round)->
        entrants = entrants.concat round.get 'entrants'

      entrants.uniq()
    ).property().volatile()

    matches: (->
      matches = []
      rounds = @get 'rounds'
      rounds.forEach (round, roundIndex)->
        round.get('matches').forEach (match, matchIndex)->
          matches.push match
      matches
    ).property('rounds.@each.isLoaded').volatile()

  App.Stage.toString = -> 'Stage'