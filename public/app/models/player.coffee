###
 * player
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:29
###

define ->
  App.Player = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    country: DS.belongsTo 'App.Country'
    team: DS.belongsTo 'App.Team'
    matches: DS.hasMany 'App.Match'
    countryFlagClassName: (->
      'country-flag-icon-%@'.fmt @get 'country.code'
    ).property('country')

  App.Player.toString = -> 'Player'