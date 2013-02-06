###
 * stage
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 03:06
###

define ->
  App.Stage = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'

    rounds: DS.belongsTo 'App.Championship'

  App.Stage.toString = -> 'Stage'