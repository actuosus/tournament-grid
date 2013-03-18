###
 * bracket
 * @author: actuosus
 * @fileOverview Bracket model.
 * Date: 10/03/2013
 * Time: 03:06
###

define ->
  App.Bracket = DS.Model.extend
    rounds: DS.hasMany('App.Round')