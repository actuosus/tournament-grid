###
 * team_ref
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 11:01
###

define ['cs!../core'],->
  App.TeamRef = DS.Model.extend
    primaryKey: '_id'

    link: Em.computed.alias 'team.link'

    # Relations
    team: DS.belongsTo 'App.Team'
    report: DS.belongsTo('App.Report', {inverse: 'teamRefs'})
    round: DS.belongsTo('App.Round', {inverse: 'teamRefs'})
    match: DS.belongsTo('App.Match', {inverse: 'teamRefs'})
    captain: DS.belongsTo 'App.Player'

    players: DS.hasMany('App.Player', {inverse: 'teamRef'})

    hasCaptain: (-> @get 'captain' ).property('players.@each.isCaptain')

  App.TeamRef.toString = -> 'TeamRef'