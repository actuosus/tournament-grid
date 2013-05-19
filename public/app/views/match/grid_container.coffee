###
 * grid_container
 * @author: actuosus
 * Date: 09/05/2013
 * Time: 21:24
###

define [
  'cs!../../core'
  'cs!./grid_item'
], ->
  App.MatchGridContainer = Em.ContainerView.extend
    classNames: ['grid-container', 'match-grid-container']
    childViews: ['toolbarView', 'contentView']

    toolbarView: Em.ContainerView.extend
      classNames: 'toolbar'
      childViews: ['addButtonView']

      stageBinding: 'parentView.stage'
      contentBinding: 'parentView.content'

      addButtonView: Em.View.extend
        classNames: ['btn', 'add']
        attributeBindings: ['title']
        title: '_add_match'.loc()

        stageBinding: 'parentView.stage'
        contentBinding: 'parentView.content'
        template: Em.Handlebars.compile '+'

        click: ->
          @get('content').pushObject App.Match.createRecord round: @get 'stage.rounds.firstObject'

    contentView: App.GridView.extend
      classNames: ['match-grid']
      itemViewClass: App.MatchGridItemView
      stageBinding: 'parentView.stage'
      contentBinding: 'parentView.content'