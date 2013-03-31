###
 * team
 * @author: actuosus
 * @fileOverview Team model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core'],->
  App.Team = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    country: DS.belongsTo 'App.Country'
#    country: Em.computed -> App.Country.createRecord name: 'Япония', code: 'jp'
    countryFlagClassName: (->
      'country-flag-icon-%@'.fmt @get 'country.code'
    ).property('country')

    isSelected: no


    players: DS.hasMany 'App.Player'
#    toString: -> "<Team:#{@get 'name'}>"

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