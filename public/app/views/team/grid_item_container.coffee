###
 * grid_item_container
 * @author: actuosus
 * Date: 07/04/2013
 * Time: 18:50
###

define [
  'cs!../../core'
  'cs!./grid_item'
], ->
  App.TeamGridItemContainerView = Em.ContainerView.extend
    classNames: ['team-grid-item-container']
    classNameBindings: ['isHighlighted']
    isHighlightedBinding: 'content.isHighlighted'
    childViews: ['teamGridItemView']
    pointsIsVisible: yes

    teamGridItemView: App.TeamGridItemView.extend
      contentIndexBinding: 'parentView.contentIndex'
      contentBinding: 'parentView.content'
      matchBinding: 'parentView.match'
      pointsIsVisibleBinding: 'parentView.pointsIsVisible'