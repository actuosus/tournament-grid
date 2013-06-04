###
 * round
 * @author: actuosus
 * @fileOverview Round model.
 * Date: 21/01/2013
 * Time: 14:25
###

define ['cs!../core'],->
  App.Round = DS.Model.extend
    primaryKey: '_id'
    sort_index: DS.attr 'number'

    # TODO History Ember.History,
#    _trackProperties: ['name']

    name: DS.attr('string', {loc: {keyPath: '_name', defaultLanguage: 'ru'}})

    # Relations
    matches: DS.hasMany 'App.Match'
    resultSets: DS.hasMany 'App.ResultSet'

    stage: DS.belongsTo('App.Stage', {inverse: 'rounds'})
    bracket: DS.belongsTo('App.Bracket', {inverse: 'rounds'})

    teamRefs: DS.hasMany 'App.TeamRef'

    # TODO Make localization
#    _name: DS.attr('object')
#    __name: (->
#      nameHash = @get '_name'
#      currentLanguage = App.get('currentLanguage')
#      value = ''
#      if currentLanguage and nameHash
#        value = nameHash[currentLanguage]
#      unless value
#        value = @get 'name'
#      value
#    ).property('_name', 'App.currentLanguage').volatile()

    parentReference: 'stage'
    parent: (-> @get @get 'parentReference').property('stage')
    children: (-> @get 'matches').property('matches')

    treeItemChildren: (-> @get 'matches').property('matches')

    getDescendant: (child, idx)-> child.get('children').objectAt idx if child

    getByPath: (path, root = @)->
      if path
        splittedPath = path.split '.'
        lastChild = @getDescendant root, splittedPath[0]
        for idx in [1...splittedPath.length]
          lastChild = @getDescendant lastChild, splittedPath[idx]
        lastChild

    left: null
    right: null

    itemIndex: (->
      parent = @get 'parent'
      if parent
        parent.get('rounds').indexOf @
    ).property()

    entrants: (->
      matches = @get 'matches'
      entrants = []
      matches.forEach (match)->
        entrants.push match.get 'entrant1'
        entrants.push match.get 'entrant2'
      entrants.uniq()
    ).property('matches.@each.isLoaded')

  App.Round.toString = -> 'Round'