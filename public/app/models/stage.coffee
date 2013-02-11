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
    description: DS.attr 'string'
    visual_type: DS.attr 'string'
    sort_index: DS.attr 'number'
    entrants_count: DS.attr 'number'

    rounds: DS.hasMany 'App.Round'

  App.Stage.toString = -> 'Stage'