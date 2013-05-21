###
 * team_ref
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 11:01
###

define ['cs!../core'],->
  App.TeamRef = DS.Model.extend
    primaryKey: '_id'

    team: DS.belongsTo 'App.Team'
    report: DS.belongsTo('App.Report', {inverse: 'teamRefs'})
    match: DS.belongsTo 'App.Match'

    players: DS.hasMany('App.Player', {inverse: 'teamRef'})

    hasCaptain: (->
#      console.log 'Finding the captain', @get('players').findProperty 'isCaptain', yes
#      !!@get('players').findProperty 'isCaptain', yes
      @get 'captain'
    ).property('players.@each.isCaptain')

    captain: DS.belongsTo 'App.Player'

  App.TeamRef.toString = -> 'TeamRef'