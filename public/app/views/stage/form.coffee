###
 * form
 * @author: actuosus
 * @fileOverview Stage form
 * Date: 12/03/2013
 * Time: 06:12
###

define [
  'text!../../templates/stage/form.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.stageForm = Em.Handlebars.compile template
  App.StageForm = Em.View.extend
    tagName: 'form'
    classNames: ['stage-form', 'form-vertical']
    templateName: 'stageForm'

    visualType: 'grid'

    name: null
    description: null

    didCreate: Em.K

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')
      entransNumber = parseInt(@$('.entrants-number').val(), 10)
      report = @get 'report'
      stage = window.createActualRoundsByEntrants(entransNumber)
##      stage = App.Stage.createRecord
#      stage.set 'name', @$('.name').val()
      stage.set 'report', report
      stage.set 'name', @get 'name'
#      stage.set 'description', @$('.description').val()
      stage.set 'description', @get 'description'
      stage.set 'visual_type', @get 'visualType.id'

      if report
        report.get('stages').pushObject stage
#
##        name: @$('.name').val()
##        description: @$('.description').val()
##        visual_type: @get 'visualType'
#      stage.on 'didCreate', => @didCreate stage
#      stage.on 'becameError', =>
#        console.log arguments
#        stage.destroy()
##      App.store.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()
