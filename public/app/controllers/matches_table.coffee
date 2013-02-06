###
 * matches_table
 * @author: actuosus
 * @fileOverview 
 * Date: 02/02/2013
 * Time: 00:12
###

define ->
  App.MatchesTableController = Ember.ObjectController.extend
    content: null
    teams: null
    types: null
    periods: null
    currentTeam: null
    currentType: null
    currentPeriod: null

    filter: -> console.log arguments