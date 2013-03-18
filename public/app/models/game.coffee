###
 * game
 * @author: actuosus
 * @fileOverview Game model.
 * Date: 06/02/2013
 * Time: 05:21
###

define ->
  App.Game = DS.Model.extend
    primaryKey: '_id'
    title: DS.attr 'string'
    link: DS.attr 'string'
    match: DS.belongsTo 'App.Match'

  App.Game.toString = -> 'Game'