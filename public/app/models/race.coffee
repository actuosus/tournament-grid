###
 * race
 * @author: actuosus
 * Date: 09/04/2013
 * Time: 22:23
###

define ['cs!../core'],->
  App.Race = DS.Model.extend
    primaryKey: '_id'
    identifier: DS.attr 'string'
    icon_url: DS.attr 'string'
    title: DS.attr 'string'