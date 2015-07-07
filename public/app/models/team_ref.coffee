###
 * team_ref
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 11:01
###

define ['cs!../core', 'cs!./entrant'], ->
  App.TeamRef = App.Entrant.extend
    link: Em.computed.alias 'team.link'

  # Relations
    team: DS.belongsTo('team', {serialize: 'records', embedded: 'always'})
    report: DS.belongsTo('report', {inverse: 'teamRefs'})
    round: DS.belongsTo('round', {inverse: 'teamRefs'})
#    match: DS.belongsTo('match', {inverse: 'teamRefs'})
    captain: DS.belongsTo 'player'

    players: DS.hasMany('player', {inverse: 'teamRef', embedded: 'always'})

    teamRef: (-> @).property()
    hasCaptain: (-> @get 'captain' ).property('players.@each.isCaptain')

  App.TeamRef.toString = -> 'TeamRef'