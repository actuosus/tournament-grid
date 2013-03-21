###
 * bracket
 * @author: actuosus
 * @fileOverview Bracket model.
 * Date: 10/03/2013
 * Time: 03:06
###

define ->
  App.Bracket = DS.Model.extend
    parent: (-> @get 'stage').property('stage')
    children: (-> @get 'rounds').property('rounds')

    getDescendant: (child, idx)-> child.get('children').objectAt idx if child

    getByPath: (path, root = @)->
      if path
        splittedPath = path.split '.'
        lastChild = @getDescendant root, splittedPath[0]
        for idx in [1...splittedPath.length]
          lastChild = @getDescendant lastChild, splittedPath[idx]
        lastChild

    name: DS.attr 'string'
    stage: DS.belongsTo 'App.Stage'
    rounds: DS.hasMany 'App.Round'

  App.Bracket.toString = -> 'Bracket'