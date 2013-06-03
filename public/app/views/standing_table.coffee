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
  App.StandingTableView = Em.ContainerView.extend
    classNames: ['standing-table']
    childViews: ['standingsView', 'contentView']
    standingsView: App.TeamStandingsTableView.extend
      matchesBinding: 'parentView.matches'
      contentBinding: 'parentView.matches.results'
    contentView: App.MatchesTableContainerView.extend
      entrantsBinding: 'parentView.entrants'
      contentBinding: 'parentView.matches'
      showFilterFormBinding: 'parentView.showFilterForm'
      tableItemViewClassBinding: 'parentView.tableItemViewClass'
