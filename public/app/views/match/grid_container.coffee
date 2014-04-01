###
 * grid_container
 * @author: actuosus
 * Date: 09/05/2013
 * Time: 21:24
###

define [
  'cs!../../core'
  'cs!./item'
], ->
  App.MatchGridContainer = Em.ContainerView.extend App.ContextMenuSupport,# App.Editing, App.VisualySelectable,
    classNames: ['grid-container', 'match-grid-container']
    childViews: ['contentView']

#    _isEditingBinding: 'App.isEditingMode'
#    editingChildViews: ['actionBar']

#    actionBar: App.ActionBarView.extend
#      content: [
#        Em.Object.create({id: 'add', title: 'Add match'}),
#        Em.Object.create({id: 'open', title: 'Open match'}),
#        Em.Object.create({id: 'close', title: 'Close match'}),
#        Em.Object.create({id: 'edit', title: 'Edit match'}),
#        Em.Object.create({id: 'delete', title: 'Delete match'})
#      ]
#      targetBinding: 'parentView.visualSelection'
#      targetChanged: (->
#        console.log('target changed', @get('target'))
#        targets = @get('target')
#        actions = @get 'content'
#        canBeOpened = no
#        canBeClosed = no
#        targets.forEach (target)-> canBeOpened = yes if target.get 'canBeOpened'
#        targets.forEach (target)-> canBeClosed = yes if target.get 'isOpened'
#        actions.findProperty('id', 'open').set('isHidden', not canBeOpened)
#        actions.findProperty('id', 'close').set('isHidden', not canBeClosed)
#
#      ).observes('target')

    selectableElementsView: Em.computed.alias 'contentView'

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['add:addMatch', 'closeAll', 'openAll']

    visualSelectionChanged: (->
      if @get('visualSelection.length') > 0
        @get('contextMenuActions').pushObject 'removeSelected'
      else
        @get('contextMenuActions').removeObject 'removeSelected'
    ).observes('visualSelection.length')

#    removeSelected: ->
#      @get('visualSelection').forEach (item) ->
#        item.deleteRecord()
#      App.store.commit()

#    removeAll: ->
#      @get('content').forEach (item) -> item.deleteRecord()
#      App.store.commit()

    openAll: ->
      @get('content').forEach (item)->
        item.open()

#    openSelected: ->
#      @get('visualSelection').forEach (item)->
#        item.open()

    closeAll: ->
      @get('content').forEach (item)->
        item.close()

#    closeSelected: ->
#      @get('visualSelection').forEach (item)->
#        item.close()

    add: ->
      stage = @get 'stage'
      round = @get 'stage.rounds.firstObject'
      unless round
        rounds = @get 'stage.rounds'
        round = rounds.createRecord({'stage': stage})
        round.save()
        @set 'content', round.get 'matches'
      match = round.get('matches').createRecord({status: 'opened', round: round})
#      @get('content').pushObject match

    contentView: App.GridView.extend
      classNames: ['match-grid']
      itemViewClass: App.MatchItemView.extend
        classNames: ['match-grid-item']
      stageBinding: 'parentView.stage'
      contentBinding: 'parentView.content'