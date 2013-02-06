###
 * standing_table
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 04:09
###

define ['cs!views/team_standings_table', 'cs!views/matches_table_container'], ()->
  console.log arguments
  App.StangingTableView = Em.ContainerView.extend
    classNames: ['standing-table']
    childViews: ['stadingsView', 'matchesView'],
    stadingsView: App.TeamStandingsTableView.extend
      contentBinding: 'parentView.teams'
    matchesView: App.MatchesTableContainerView.extend
      contentBinding: 'parentView.matches'
