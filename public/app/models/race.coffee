###
 * race
 * @author: actuosus
 * Date: 09/04/2013
 * Time: 22:23
###

define ['cs!../core'],->
  App.Race = DS.Model.extend
    primaryKey: '_id'
    iconURL: DS.attr 'string'
    name: DS.attr 'string'