###
 * lineup
 * @author: actuosus
 * @fileOverview
 * Date: 05/03/2013
 * Time: 13:19
###

define [
  'cs!views/grid'
  'cs!views/team/lineup_grid_item'
], ->
  App.LineupView = Em.ContainerView.extend
    childViews: ['contentView']#, 'addEntrantView'

    contentView: App.GridView.extend
      classNames: ['lineup-grid']
      contentBinding: 'parentView.content'
      itemViewClass: App.TeamLineupGridItem

    addEntrantView: App.TeamLineupGridItem.extend
      classNames: ['boo']
