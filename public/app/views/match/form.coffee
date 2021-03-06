###
 * form
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 16:24
###

define [
  'ehbs!match/form'
  'cs!../../core'
  'cs!../form'

  'cs!../multilingual_text_field'
  'cs!../multilingual_text_area'
], (template)->
#  Em.TEMPLATES.matchForm = Em.Handlebars.compile template
  App.MatchForm = App.FormView.extend
    classNames: ['stage-form', 'form-vertical']
    templateName: 'match/form'

    createRecord: ->
      console.warn 'Should implement match creation.'

    updateRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')
      content = @get 'content'
#      transaction = content.get('store').transaction()
#      transaction.add content
      content.on 'didUpdate', => @didUpdate content
#      content.set 'title', @get 'title'
#      content.set 'map_type', @get 'map_type'
#      content.set 'description', @get 'description'
#      transaction.commit()
      content.save()
      content.get('store').flushPendingSave()

    cancel: ->
      @get('content')?.rollback()
      @popupView?.hide()

    submit: (event)->
      event.preventDefault()
      if @get 'content'
        @updateRecord()
      else
        @createRecord()

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        if @get 'content'
          @updateRecord()
        else
          @createRecord()
      if $(event.target).hasClass('cancel-btn')
        @cancel()