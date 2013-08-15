###
 * bracket
 * @author: actuosus
 * @fileOverview Bracket model.
 * Date: 10/03/2013
 * Time: 03:06
###

define ['cs!../core'],->
  App.Bracket = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'

    # Relations
    stage: DS.belongsTo 'App.Stage'
    rounds: DS.hasMany 'App.Round'

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

  App.Bracket.toString = -> 'Bracket'