###
 * player
 * @author: actuosus
 * @fileOverview Player model.
 * Date: 21/01/2013
 * Time: 07:29
###

define ['cs!../core'],->
  App.Player = DS.Model.extend
    primaryKey: '_id'
    nickname: DS.attr 'string'
    firstName: DS.attr 'string'
    middleName: DS.attr 'string'
    lastName: DS.attr 'string'
    is_captain: DS.attr 'boolean'
    country: DS.belongsTo 'App.Country'
    team: DS.belongsTo 'App.Team'
    matches: DS.hasMany 'App.Match'
    countryFlagClassName: (->
      'country-flag-icon-%@'.fmt @get 'country.code'
    ).property('country')
    shortName: (->
      '%@ %@'.fmt @get('firstName'), @get('lastName')
    ).property('firstName', 'lastName')

  App.Player.toString = -> 'Player'