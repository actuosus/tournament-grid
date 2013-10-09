###
 * team
 * @author: actuosus
 * @fileOverview Team model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core', 'cs!./entrant'],->
  App.Team = App.Entrant.extend #Ember.History,
    primaryKey: '_id'
#    _trackProperties: [
#      'name'
#      'players'
#    ]
    name: DS.attr 'string'

    isSelected: no

    teamRef: (->
      teamRefs = App.get 'report.teamRefs'
      teamRefs?.find (_)=> Em.isEqual _.get('team'), @
    ).property()

    players: DS.hasMany('App.Player', {inverse: 'team'})

    hasCaptain: (->
      !!@get('players').findProperty 'is_captain', yes
    ).property('players.@each.is_captain')

  App.Team.toString = -> 'Team'