###
 * team
 * @author: actuosus
 * @fileOverview Team model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core', 'cs!./entrant'], ->
  App.Team = App.Entrant.extend #Ember.History,
#    _trackProperties: [
#      'name'
#      'players'
#    ]
    name: DS.attr 'string'

    isSelected: no

  # Relations
    teamRef: DS.hasMany('teamRef', {async: true})
    players: DS.hasMany('player', {inverse: 'team', embedded: 'always'})

    hasCaptain: (->
      !!@get('players').findProperty 'is_captain', yes
    ).property('players.@each.is_captain')

  App.Team.toString = -> 'Team'