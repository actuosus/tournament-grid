###
 * round
 * @author: actuosus
 * @fileOverview Round model.
 * Date: 21/01/2013
 * Time: 14:25
###

define ['cs!../core'],->
  App.Round = DS.Model.extend Ember.History,
    primaryKey: '_id'
    _trackProperties: ['name']
    name: DS.attr('string', {loc: {keyPath: '_name', defaultLanguage: 'ru'}})
    __name: (->
      console.log arguments
      nameHash = @get '_name'
      currentLanguage = App.get('currentLanguage')
      value = ''
      if currentLanguage and nameHash
        value = nameHash[currentLanguage]
      unless value
        value = @get 'name'
      value
    ).property('_name', 'App.currentLanguage').volatile()

    _name: DS.attr('object')

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

    matches: DS.hasMany 'App.Match'
    results: DS.hasMany 'App.Result'

    stage: DS.belongsTo 'App.Stage'
    bracket: DS.belongsTo 'App.Bracket'

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