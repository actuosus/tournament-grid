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
  App.MatchGridContainer = Em.ContainerView.extend App.ContextMenuSupport, App.VisualySelectable,
    classNames: ['grid-container', 'match-grid-container']
    childViews: ['toolbarView', 'contentView']

    selectableElementsView: Em.computed.alias 'contentView'

    contextMenuActions: ['add:addMatch', 'removeAll', 'closeAll', 'openAll']

    visualSelectionChanged: (->
#      console.log 'visualSelectionChanged'
      if @get('visualSelection.length') > 0
        @get('contextMenuActions').pushObject 'removeSelected'
      else
        @get('contextMenuActions').removeObject 'removeSelected'
    ).observes('visualSelection.length')

    removeSelected: ->
      @get('visualSelection').forEach (item) -> item.deleteRecord()
      App.store.commit()

    removeAll: ->
      @get('content').forEach (item) -> item.deleteRecord()
      App.store.commit()

    openAll: ->
      @get('content').forEach (item) -> item.open()

    openSelected: ->
      @get('visualSelection').forEach (item) -> item.open()

    closeAll: ->
      @get('content').forEach (item) -> item.close()

    closeSelected: ->
      @get('visualSelection').forEach (item) -> item.close()

    add: ->
      @get('content').pushObject App.Match.createRecord round: @get 'stage.rounds.firstObject'

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