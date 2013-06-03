###
 * result
 * @author: actuosus
 * @fileOverview Result model.
 * Date: 06/02/2013
 * Time: 03:07
###

define ['cs!../core'],->
  ###
   * @class App.Result
   * @extends DS.Model
  ###
  App.Result = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    value: DS.attr 'number'

    # Relations
    resultSet: DS.belongsTo('App.ResultSet', {inverse: 'results'})

  App.Result.toString = -> 'Result'