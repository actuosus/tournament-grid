###
 * group_table_container
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 17:53
###

define [
  'cs!./group_table'
], ()->
  App.MatchesGroupTableContainerView = Em.ContainerView.extend
    classNames: ['matches-table-container']
    childViews: ['titleView', 'tableView'],
    titleView: Em.View.extend
      classNames: ['matches-table-title']
      template: Em.Handlebars.compile('{{loc "_matches"}}')
    tableView: App.MatchesGroupTableView.extend
      contentBinding: 'parentView.content'
#    click: (event)->
#      if $(event.target).hasClass('toggle-btn-expand')
#        @.$().height(40)
