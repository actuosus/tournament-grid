###
 * entrant
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 20:19
###

define ['cs!../core'],->
  App.Entrant = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    url: DS.attr 'string'
    pro: DS.attr 'boolean'