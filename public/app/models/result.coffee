###
 * result
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 03:07
###

define ->
  App.Result = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    matches: DS.hasMany 'App.Match'

  App.Result.toString = -> 'Result'