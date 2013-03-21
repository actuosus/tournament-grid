###
 * form
 * @author: actuosus
 * @fileOverview Stage form
 * Date: 12/03/2013
 * Time: 06:12
###

define [
  'text!templates/stage/form.handlebars'
], (template)->
  Em.TEMPLATES.stageForm = Em.Handlebars.compile template
  App.StageForm = Em.View.extend
    tagName: 'form'
    classNames: ['stage-form', 'form-vertical']
    templateName: 'stageForm'

    visualType: 'grid'

    didCreate: Em.K

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

      stage = App.Stage.createRecord
        name: @$('.name').val()
        description: @$('.description').val()
        visual_type: @get 'visualType'
      stage.on 'didCreate', => @didCreate stage
      stage.on 'becameError', =>
        console.log arguments
        stage.destroy()
#      App.store.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()
