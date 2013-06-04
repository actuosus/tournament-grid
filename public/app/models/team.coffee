###
 * team
 * @author: actuosus
 * @fileOverview Team model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core'],->
  App.Team = DS.Model.extend #Ember.History,
    primaryKey: '_id'
    _trackProperties: [
      'name'
      'players'
    ]
    name: DS.attr 'string'
    country: DS.belongsTo 'App.Country'

    is_pro: DS.attr 'boolean'

    isSelected: no

    # Just for creation marking
    report: DS.belongsTo 'App.Report'

    players: DS.hasMany('App.Player', {inverse: 'team'})

    hasCaptain: (->
      !!@get('players').findProperty 'is_captain', yes
    ).property('players.@each.is_captain')

  App.Team.toString = -> 'Team'