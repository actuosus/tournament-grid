###
 * entrant
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 20:19
###

define ['cs!../core'],->
  App.Entrant = DS.Model.extend
    name: DS.attr 'string'