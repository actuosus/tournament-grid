###
 * round
 * @author: actuosus
 * @fileOverview Round model.
 * Date: 21/01/2013
 * Time: 14:25
###

define ->
  App.Round = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'

    parentReference: 'stage'
    parent: (-> @get @get 'parentReference').property('stage')
    children: (-> @get 'matches').property('matches')


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

    stage: DS.belongsTo 'App.Stage'
    bracket: DS.belongsTo 'App.Bracket'

    entrants: (->
      matches = @get 'matches'
      entrants = []
      matches.forEach (match)->
        entrants.push match.get 'entrant1'
        entrants.push match.get 'entrant2'
      entrants.uniq()
    ).property().volatile()

  App.Round.toString = -> 'Round'