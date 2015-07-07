###
 * form
 * @author: actuosus
 * @fileOverview Stage form
 * Date: 12/03/2013
 * Time: 06:12
###

define [
  'ehbs!stage/form'
  'cs!../../core'
  'cs!../form'

  'cs!../multilingual_text_field'
  'cs!../multilingual_text_area'
], (template)->
#  Em.TEMPLATES.stageForm = Em.Handlebars.compile template
  App.StageForm = App.FormView.extend
    classNames: ['stage-form', 'form-vertical']
    templateName: 'stage/form'

    visualType: 'grid'

    rating: null
    title: null
    description: null

    submitButtonLabel: (->
      if @get 'hasValidContent'
        '_save'.loc()
      else
        '_create'.loc()
    ).property('content')

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

      # TODO Resolve creation.
      switch @get 'visualType.id'
        when 'grid'
          stage = report.createStageByEntrants entrantsNumber
        when 'single', 'double', 'group'
          stage = report.get('stages').createRecord()
        when 'team'
          stage = report.get('stages').createRecord()
          # Creating just one round.
#          rounds = stage.get('rounds')
#          round = rounds.createRecord({sort_index: 0, stage: stage})
#          rounds.pushObject round
#          round.save()
        when 'matrix'
          stage = report.get('stages').createRecord()
#          rounds = stage.get('rounds')
#          round = rounds.createRecord({sort_index: 0, stage: stage})
#          rounds.pushObject round
#          round.set 'stage', stage

      stage.set 'sortIndex', report.get('stages.length')
      stage.set 'report', report
      stage.set 'title', @get 'content.title'
      stage.set 'rating', @get 'content.rating'
      stage.set 'entrantsNumber', entrantsNumber
      stage.set 'description', @get 'content.description'
      stage.set 'visualType', @get 'visualType.id'

      report.get('stages').pushObject stage if report

      # TODO Kind of hacky.
      @didCreate stage

    updateRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')
      content = @get 'content'
      content.on 'didUpdate', => @didUpdate content
      content.save()

    cancel: ->
#      @get('content')?.rollback()
      @popupView?.hide()

    hasValidContent: (->
      App.Stage.detectInstance @get('content')
    ).property('content')

    submit: (event)->
      event.preventDefault()
      if @get 'hasValidContent'
        @updateRecord()
      else
        @createRecord()

    click: (event)->
      if $(event.target).hasClass('cancel-btn')
        @cancel()
        @trigger('cancel', event)
