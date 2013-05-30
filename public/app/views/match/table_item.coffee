###
 * table_item
 * @author: actuosus
 * Date: 29/05/2013
 * Time: 13:37
###

define [
  'text!../../templates/match/table_item.handlebars'
], (template)->
  Em.TEMPLATES.matchesTableItem = Em.Handlebars.compile template

  App.MatchTableItemView = Em.View.extend(App.ContextMenuSupport, {
    tagName: 'tr'
    classNames: ['matches-table-item']
    classNameBindings: ['content.isDirty', 'content.isSaving', 'content.invalid']
    attributeBindings: ['title']
    templateName: 'matchesTableItem'

    titleBinding: 'content.description'

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['open', 'close', 'edit', 'save', 'deleteRecord:delete']
#    contextMenuTargetBinding: 'content'

    hasPointsOrEditable: (->
      @get('content.hasPoints') or App.get('isEditingMode')
    ).property('content.hasPoints', 'App.isEditingMode')

    open: ->
      content = @get 'content'
      content.open()
      console.log 'Should be opened'

    close: ->
      content = @get 'content'
      content.close()
      console.log 'Should be closed'

    deleteRecord: ->
      content = @get 'content'
      content.deleteRecord()
      content.store.commit()

    save: ->
      content = @get 'content'
      content.store.commit()

    click: (event)->
      if $(event.target).hasClass('save-btn')
        match = @get 'content'
        match.get('store').commit()
      if $(event.target).hasClass('remove-btn')
        match = @get 'content'
        match.deleteRecord() if match
  })