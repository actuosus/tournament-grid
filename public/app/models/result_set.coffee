###
 * result_set
 * @author: actuosus
 * Date: 30/05/2013
 * Time: 21:26
###

define ->
  App.ResultSet = DS.Model.extend
    sortIndex: DS.attr 'number'
    isSelected: DS.attr 'boolean'

  # Relations
    entrant: DS.belongsTo('entrant', {polymorphic: yes, async: yes})
    round: DS.belongsTo('round', {inverse: 'resultSets'})

    results: DS.hasMany('result', {inverse: 'resultSet'})
    matches: DS.hasMany 'match'

  # TODO Resolve storage.
    position: DS.attr 'number'
    matchesPlayed: DS.attr 'number'
    wins: DS.attr 'number'
    draws: DS.attr 'number'
    losses: DS.attr 'number'
    points: DS.attr 'number'
    difference: DS.attr 'string'

  App.ResultSet.toString = -> 'ResultSet'