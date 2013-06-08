###
 * lineup
 * @author: actuosus
 * @fileOverview
 * Date: 05/03/2013
 * Time: 13:19
###

define [
  'cs!./grid'
  'cs!./team/lineup_grid_item'
], ->
  App.LineupView = Em.ContainerView.extend App.ContextMenuSupport, App.VisualySelectable,
    childViews: ['contentView']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['add', 'removeAll']

    selectableElementsView: Em.computed.alias 'contentView'

    contentView: App.GridView.extend
      classNames: ['lineup-grid']
      contentBinding: 'parentView.content'

      emptyView: App.EmptyView

      itemViewClass: App.TeamLineupGridItem
