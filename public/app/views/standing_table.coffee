###
 * standing_table
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 04:09
###

define [
  'cs!./team/standings_table',
  'cs!./match/table_container'
], ()->
  App.StangingTableView = Em.ContainerView.extend
    classNames: ['standing-table']
    childViews: ['stadingsView', 'contentView']
    stadingsView: App.TeamStandingsTableView.extend
      contentBinding: 'parentView.entrants'
    contentView: App.MatchesTableContainerView.extend
#      controller: App.MatchesTableController.extend
#        teamsBinging: 'view.parentView.teams'
#        contentBinding: 'view.content'
      contentBinding: 'parentView.matches'
