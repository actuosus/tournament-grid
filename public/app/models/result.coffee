###
 * result
 * @author: actuosus
 * @fileOverview Result model.
 * Date: 06/02/2013
 * Time: 03:07
###

define ['cs!../core'],->
  App.Result = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    matches: DS.hasMany 'App.Match'

  App.Result.toString = -> 'Result'