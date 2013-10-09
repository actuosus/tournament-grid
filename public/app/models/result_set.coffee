###
 * result_set
 * @author: actuosus
 * Date: 30/05/2013
 * Time: 21:26
###

define ->
  App.ResultSet = DS.Model.extend
    primaryKey: '_id'
    sortIndex: DS.attr 'number'
    isSelected: DS.attr 'boolean'

    # Relations
    entrant: DS.belongsTo('App.Entrant',{polymorphic: yes})
    round: DS.belongsTo('App.Round', {inverse: 'resultSets'})

    results: DS.hasMany('App.Result', {inverse: 'resultSet'})
    matches: DS.hasMany 'App.Match'

    # TODO Resolve storage.
    position: DS.attr 'number'
    matchesPlayed: DS.attr 'number'
    wins: DS.attr 'number'
    draws: DS.attr 'number'
    losses: DS.attr 'number'
    points: DS.attr 'number'
    difference: DS.attr 'number'

  App.ResultSet.toString = -> 'ResultSet'