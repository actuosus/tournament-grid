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

  App.MatchTableItemView = Em.View.extend(App.MatchDelegate, {
    tagName: 'tr'
    classNames: ['matches-table-item']
    classNameBindings: ['content.isDirty', 'content.isSaving', 'content.invalid']
    attributeBindings: ['title']
    templateName: 'matchesTableItem'

    entrantsBinding: 'parentView.entrant'

    titleBinding: 'content.description'

    hasPointsOrEditable: (->
      console.log 'hasPointsOrEditable', @get('content.hasPoints')
      @get('content.hasPoints') or App.get('isEditingMode')
    ).property('content.hasPoints', 'App.isEditingMode')

    hasPointsChanged: (->
      console.log 'hasPointsChanged', @get('content.hasPoints')
      @set 'hasPointsOrEditable', @get('content.hasPoints') or App.get('isEditingMode')
    ).observes('content.hasPoints')

    click: (event)->
      if $(event.target).hasClass('save-btn')
        match = @get 'content'
        match.get('store').commit()
      if $(event.target).hasClass('remove-btn')
        match = @get 'content'
        match.deleteRecord() if match
  })