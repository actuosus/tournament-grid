###
 * match
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:29
###

define ->
  App.Match = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    description: DS.attr 'string'
    date: DS.attr 'date'
    map_type: DS.attr 'string'
    type: DS.attr 'string'
    status: DS.attr 'string'
#    championship: type: ObjectId, ref: 'Championship'
    team1: DS.belongsTo 'App.Team'
    team2: DS.belongsTo 'App.Team'
    team1_points: DS.attr 'number'
    team2_points: DS.attr 'number'
    player1_points: DS.attr 'number'
    player2_points: DS.attr 'number'
    player1_race_id: DS.attr 'number'
    player2_race_id: DS.attr 'number'

    round: DS.belongsTo 'App.Round'

    games: DS.hasMany 'App.Game'

    winner: (->
      if @get('team1_points') > @get('team2_points')
        return @get 'team1'
      else
        return @get 'team2'
    ).property('team1', 'team2')

    longDateString: (-> moment(@get 'date').format('LLLL')).property 'date'

  App.Match.toString = -> 'Match'