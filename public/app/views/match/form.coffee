###
 * form
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 16:24
###

define [
  'text!../../templates/match/form.hbs'
  'cs!../../core'
  'cs!../form'

  'cs!../multilingual_text_field'
  'cs!../multilingual_text_area'
], (template)->
  Em.TEMPLATES.matchForm = Em.Handlebars.compile template
  App.MatchForm = App.FormView.extend
    classNames: ['stage-form', 'form-vertical']
    templateName: 'matchForm'

    didCreate: Em.K
    didUpdate: Em.K

    createRecord: ->
      console.debug 'Should implement match creation.'

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
      content.get('store').commit()

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