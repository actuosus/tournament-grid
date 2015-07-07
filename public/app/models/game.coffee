###
 * game
 * @author: actuosus
 * @fileOverview Game model.
 * Date: 06/02/2013
 * Time: 05:21
###

define ['cs!../core'], ->
  App.Game = DS.Model.extend
#    primaryKey: '_id'
    title: DS.attr 'string'
    link: DS.attr 'string'

  # Relationships
    match: DS.belongsTo('match', {inverse: 'games'})

  App.Game.toString = -> 'Game'