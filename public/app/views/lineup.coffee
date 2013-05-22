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
  App.LineupView = Em.ContainerView.extend
    childViews: ['contentView']#, 'addEntrantView'

    contentView: App.GridView.extend
      classNames: ['lineup-grid']
      contentBinding: 'parentView.content'

#      emptyView: Em.View.extend
#        classNames: ['empty-view']
#        template: Em.Handlebars.compile '{{loc "_nothing_to_display"}}'

      itemViewClass: App.TeamLineupGridItem

    addEntrantView: App.TeamLineupGridItem.extend
      classNames: ['boo']
