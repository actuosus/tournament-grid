###
 * matches_table_container
 * @author: actuosus
 * @fileOverview 
 * Date: 28/01/2013
 * Time: 22:26
###

define ['cs!views/match_filter_form', 'cs!views/matches_table'], ()->
  console.log arguments
  App.MatchesTableContainerView = Em.ContainerView.extend
    classNames: ['matches-table-container']
    childViews: ['filterView', 'tableView'],
    filterView: App.MatchFilterFormView.extend
      contentBinding: 'parentView.content'
    tableView: App.MatchesTableView.extend
      contentBinding: 'parentView.content'
#    click: (event)->
#      if $(event.target).hasClass('toggle-btn-expand')
#        @.$().height(40)
