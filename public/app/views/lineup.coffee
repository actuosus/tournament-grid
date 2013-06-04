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
  App.LineupView = Em.ContainerView.extend App.ContextMenuSupport,
    childViews: ['contentView']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['add', 'removeAll', 'closeAll', 'openAll']

    contentView: App.GridView.extend(App.VisualySelectable, {
      classNames: ['lineup-grid']
      contentBinding: 'parentView.content'

#      emptyView: Em.View.extend
#        classNames: ['empty-view']
#        template: Em.Handlebars.compile '{{loc "_nothing_to_display"}}'

      itemViewClass: App.TeamLineupGridItem
    })
