###
 * standing_table
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 04:09
###

define [
  'cs!views/team/standings_table',
  'cs!views/match/table_container'
], ()->
  App.StangingTableView = Em.ContainerView.extend
    classNames: ['standing-table']
    childViews: ['stadingsView', 'matchesView'],
    stadingsView: App.TeamStandingsTableView.extend
      contentBinding: 'parentView.teams'
    matchesView: App.MatchesTableContainerView.extend
#      controller: App.MatchesTableController.extend
#        teamsBinging: 'view.parentView.teams'
#        contentBinding: 'view.content'
      contentBinding: 'parentView.matches'
