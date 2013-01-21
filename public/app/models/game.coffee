###
 * game
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:29
###

define ->
  App.Game = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'