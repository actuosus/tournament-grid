###
 * form
 * @author: actuosus
 * @fileOverview Stage form
 * Date: 12/03/2013
 * Time: 06:12
###

define [
  'text!../../templates/stage/form.hbs'
  'cs!../../core'
  'cs!../form'

  'cs!../multilingual_text_field'
  'cs!../multilingual_text_area'
], (template)->
  Em.TEMPLATES.stageForm = Em.Handlebars.compile template
  App.StageForm = App.FormView.extend
    classNames: ['stage-form', 'form-vertical']
    templateName: 'stageForm'

    visualType: 'grid'

    rating: null
    title: null
    description: null

    didCreate: Em.K

    isGroupType: (->
      visualType = @get 'visualType.id'
      yes if visualType is 'group'
    ).property('visualType')

    isGridType: (->
      visualType = @get 'visualType.id'
      yes if visualType is 'single' or visualType is 'grid'
    ).property('visualType')

    isDoubleType: (->
      visualType = @get 'visualType.id'
      yes if visualType is 'double'
    ).property('visualType')

    isMatrixType: (->
      visualType = @get 'visualType.id'
      yes if visualType is 'matrix'
    ).property('visualType')

    isTeamType: (->
      visualType = @get 'visualType.id'
      yes if visualType is 'team'
    ).property('visualType')

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')
      entrantsNumber = parseInt(@$('.entrants-number input').val(), 10)
      report = @get 'report'

      switch @get 'visualType.id'
        when 'grid'
          stage = report.createStageByEntrants entrantsNumber
        when 'single'
          stage = report.get('stages').createRecord()
        when 'double'
          stage = report.get('stages').createRecord()
        when 'group'
          stage = report.createStageByRoundsNumber parseInt(@$('.group-number').val(), 10)
        when 'matrix'
          stage = report.createStageByMatchesNumber parseInt(@$('.matrix-matches-number').val(), 10)
        when 'team'
          stage = report.createStageByMatchesNumber parseInt(@$('.team-matches-number').val(), 10)
##      stage = App.Stage.createRecord
#      stage.set 'name', @$('.name').val()
      stage.set 'report', report
      stage.set 'title', @get 'title'
      stage.set 'rating', @get 'rating'
      stage.set 'entrantsNumber', entrantsNumber
#      stage.set 'description', @$('.description').val()
      stage.set 'description', @get 'description'
      stage.set 'visualType', @get 'visualType.id'

      report.get('stages').pushObject stage if report

      # TODO Kind of hacky.
      @didCreate stage

    cancel: ->
      @get('content')?.rollback()
      @popupView?.hide()

    submit: (event)->
      event.preventDefault()
      @createRecord()

    click: (event)->
      if $(event.target).hasClass('cancel-btn')
        @cancel()
        @trigger('cancel', event)
