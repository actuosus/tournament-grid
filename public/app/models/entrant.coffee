###
 * entrant
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 20:19
###

define ['cs!../core'], ->
  App.Entrant = DS.Model.extend
#    primaryKey: '_id'
    link: DS.attr 'string'
#    is_pro: DS.attr 'boolean'
    type: null

    url: Em.computed.alias 'link'

  # Relations
    country: DS.belongsTo 'country'
  # Just for creation marking
    report: DS.belongsTo 'report'

  App.Entrant.toString = -> 'Entrant'