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

    # Relations
    country: DS.belongsTo 'App.Country'

    team: DS.belongsTo 'App.Team'
    teamRef: DS.belongsTo('App.TeamRef', {inverse: 'players'})

    matches: DS.hasMany 'App.Match'

    link: DS.attr 'string'

    url: (->
      link = @get 'link'
      if link
        link
      else
        "/players/#{@get 'id'}"
    ).property('link')

    # TODO Should be moved to team reference
    isCaptain: DS.attr 'boolean'

    race: DS.belongsTo 'App.Race'

    # Just for creation marking
    report: DS.belongsTo 'App.Report'

    shortName: (->
      [@get('firstName'), @get('lastName')].compact().join(' ')
    ).property('firstName', 'lastName')

    # TODO Do we actualy need full name. Observers!
    fullName: (->
      [@get('firstName'), @get('middleName'), @get('lastName')].compact().join(' ')
    ).property('firstName', 'middleName', 'lastName')

  App.Player.toString = -> 'Player'