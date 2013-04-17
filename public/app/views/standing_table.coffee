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
#      roundBinding: 'parentView.matches.round'
#      automaticCountingDisabledChanged: (->
#        if @get 'round.automaticCountingDisabled'
#          Ember.bind(@, 'content', 'parentView.matches.lastResults')
##          @set 'contentBinding', 'parentView.matches.lastResults'
#        else
#          Ember.bind(@, 'content', 'parentView.matches.results')
##          @set 'contentBinding', 'parentView.matches.results'
#
#      ).observes('round.automaticCountingDisabled')
      contentBinding: 'parentView.matches.results'
    contentView: App.MatchesTableContainerView.extend
      contentBinding: 'parentView.matches'
