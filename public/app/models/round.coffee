###
 * round
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 14:25
###

define ->
  App.Round = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    matches: DS.hasMany 'App.Match'

    rounds: DS.belongsTo 'App.Championship'

  App.Round.toString = -> 'Round'