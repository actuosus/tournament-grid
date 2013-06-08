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
    childViews: ['contentView']

    selectableElementsView: Em.computed.alias 'contentView'

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['add:addMatch', 'removeAll', 'closeAll', 'openAll']

    visualSelectionChanged: (->
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

    contentView: App.GridView.extend
      classNames: ['match-grid']
      itemViewClass: App.MatchGridItemView
      stageBinding: 'parentView.stage'
      contentBinding: 'parentView.content'