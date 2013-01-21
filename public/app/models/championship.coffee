###
 * championship
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:28
###

define ->
  App.Championship = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'