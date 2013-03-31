###
 * championship
 * @author: actuosus
 * @fileOverview Championship model.
 * Date: 21/01/2013
 * Time: 07:28
###

define ['cs!../core'],->
  App.Championship = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    start_date: DS.attr 'date'

    rounds: DS.hasMany 'App.Round'

  App.Championship.toString = -> 'Championship'