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
  'cs!../form'

  'cs!../multilingual_text_field'
  'cs!../multilingual_text_area'
], (template)->
  Em.TEMPLATES.stageForm = Em.Handlebars.compile template
  App.StageForm = App.FormView.extend
    classNames: ['stage-form', 'form-vertical']
    templateName: 'stageForm'

    visualType: 'grid'

    name: null
    rating: null
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
          stage.createWinnerBracket null, entrantsNumber
        when 'double'
          stage = report.get('stages').createRecord()
#          stage.createWinnerBracket null, entrantsNumber
#          stage.createLoserBracket null, entrantsNumber
        when 'group'
          stage = report.createStageByRoundsNumber parseInt(@$('.group-number').val(), 10)
        when 'matrix'
          stage = report.createStageByMatchesNumber parseInt(@$('.matrix-matches-number').val(), 10)
        when 'team'
          stage = report.createStageByMatchesNumber parseInt(@$('.team-matches-number').val(), 10)
##      stage = App.Stage.createRecord
#      stage.set 'name', @$('.name').val()
      stage.set 'report', report
      stage.set 'name', @get 'name'
      stage.set 'rating', @get 'rating'
      stage.set 'entrantsNumber', entrantsNumber
#      stage.set 'description', @$('.description').val()
      stage.set 'description', @get 'description'
      stage.set 'visual_type', @get 'visualType.id'

      report.get('stages').pushObject stage if report

    submit: (event)->
      event.preventDefault()
      @createRecord()
