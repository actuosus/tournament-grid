###
 * player
 * @author: actuosus
 * @fileOverview Player model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core', 'cs!./entrant'], ->
  App.Player = App.Entrant.extend
#    primaryKey: '_id'
    nickname: DS.attr 'string'
    firstName: DS.attr 'string'
#    middleName: DS.attr 'string'
    lastName: DS.attr 'string'

    name: Em.computed.alias 'nickname'

    team: DS.belongsTo 'team'
    teamRef: DS.belongsTo('teamRef', {inverse: 'players'})

#    matches: DS.hasMany 'App.Match'

  # TODO Should add race functionality
#    race: DS.belongsTo 'App.Race'

    shortName: (->
      [@get('firstName'), @get('lastName')].compact().join(' ').trim()
    ).property('firstName', 'lastName')

  # TODO Do we actualy need full name. Observers!
  #    fullName: (->
  #      [@get('firstName'), @get('middleName'), @get('lastName')].compact().join(' ')
  #    ).property('firstName', 'middleName', 'lastName')

  App.Player.toString = -> 'Player'