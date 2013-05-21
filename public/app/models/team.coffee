###
 * team
 * @author: actuosus
 * @fileOverview Team model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core'],->
  App.Team = DS.Model.extend Ember.History,
    primaryKey: '_id'
    _trackProperties: [
      'name'
      'players'
    ]
    name: DS.attr 'string'
    country: DS.belongsTo 'App.Country'
#    country: Em.computed -> App.Country.createRecord name: 'Япония', code: 'jp'
    countryFlagClassName: (->
      'country-flag-icon-%@'.fmt @get 'country.code'
    ).property('country')

    isSelected: no

    # Just for creation marking
    report: DS.belongsTo 'App.Report'

    players: DS.hasMany('App.Player', {inverse: 'team'})

#    captain: DS.belongsTo 'App.Player'
    hasCaptain: (->
      !!@get('players').findProperty 'is_captain', yes
    ).property('players.@each.is_captain')

#    matches: (-> App.Match.find({team_id: @get '_id'})).property()

#    gamesPlayed: DS.attr('number', defaultValue: 0)
#    wins: DS.attr('number', defaultValue: 0)
#    draws: DS.attr('number', defaultValue: 0)
#    loses: DS.attr('number', defaultValue: 0)
#    gamesPlayed: 0
#    wins: 0
#    draws: 0
#    loses: 0

  App.Team.toString = -> 'Team'