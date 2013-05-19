###
 * form
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 16:24
###

define [
  'text!../../templates/match/form.handlebars'
  'cs!../../core'
  'cs!../form'

  'cs!../multilingual_text_field'
  'cs!../multilingual_text_area'
], (template)->
  Em.TEMPLATES.matchForm = Em.Handlebars.compile template
  App.MatchForm = App.FormView.extend
    classNames: ['stage-form', 'form-vertical']
    templateName: 'matchForm'

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
      yes if visualType is 'single' or visualType is 'double' or visualType is 'grid'
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
      entransNumber = parseInt(@$('.entrants-number').val(), 10)
      report = @get 'report'

      switch @get 'visualType.id'
        when 'grid', 'single'
          stage = report.createStageByEntrants entransNumber
        when 'double'
          stage = report.get('stages').createRecord()
          stage.createWinnerBracket null, entransNumber
          stage.createLoserBracket null, entransNumber
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

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView