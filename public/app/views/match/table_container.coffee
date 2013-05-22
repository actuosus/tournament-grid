###
 * matches_table_container
 * @author: actuosus
 * @fileOverview
 * Date: 28/01/2013
 * Time: 22:26
###

define [
  'cs!./filter_form'
  'cs!./table'
  'cs!../../mixins/collapsable'
], ()->
  App.MatchesTableContainerView = Em.ContainerView.extend
    classNames: ['matches-table-container']
    childViews: ['filterView', 'tableView'],
    filterView: Em.ContainerView.extend
      classNames: ['match-filter-form-container']
      contentBinding: 'parentView.content'
      childViews: ['filterFormView']
      filterFormView: App.MatchFilterFormView.extend
        contentBinding: 'parentView.content'
    tableView: App.MatchesTableView.extend(App.Collapsable, {
      collapsed: yes
      toggleButtonTarget: Em.computed.alias 'parentView.filterView'
      contentBinding: 'parentView.content.filteredContent'
    })