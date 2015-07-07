###
 * form
 * @author: actuosus
 * @fileOverview
 * Date: 03/03/2013
 * Time: 20:08
###

define [
  'ehbs!player/form'
  'cs!../../core'
  'cs!../form'
], (template)->
#  Em.TEMPLATES.playerForm = Em.Handlebars.compile template
  App.PlayerForm = App.FormView.extend
    classNames: ['player-form']
    templateName: 'player/form'
    countrySelectViewBinding: 'childViews.firstObject'

    nicknameBinding: 'value'
    firstName: null
    lastName: null
    middleName: ''
    country: null

    isCaptain: no

    shouldShowRaceSelector: no

    canBeCaptain: (->
      !@get('entrant.hasCaptain')
    ).property('entrant.hasCaptain')

    didCreate: Em.K

    willInsertElement: ->
      # Derived from team
      team = @get('entrant.team') or @get('entrant')
      @set 'country', team?.get('country')

    focus: ->
      @$('.nickname').focus()

    isValid: (->
      @get('element').checkValidity()
    ).property()

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

#      country = @get 'country'
      country = @get('countrySelectView.autocompleteTextFieldView.selection')
      entrant = @get 'entrant'
      team = @get 'entrant.team'
      players = @get 'entrant.players'
      report = App.get('report')
      player = App.store.createRecord('player', {
        country: country,
        nickname: @$('.nickname').val(),
        firstName: @$('.first-name').val(),
        middleName: @$('.middle-name').val(),
        lastName: @$('.last-name').val(),
        isCaptain: @get 'isCaptain',
        report: report,
        team: team
      })

      players.addObject player if players

      player.on 'didCreate', => @didCreate player
      player.on 'becameError', =>
        @$('.save-btn').removeAttr('disabled')
        player.destroy()
      player.save()
      # TODO Save the captain!

    submit: (event)->
      # event.preventDefault()
      @createRecord()if @get 'isValid'

    click: (event)->
      event.stopPropagation()
      if $(event.target).hasClass('save-btn')
        @createRecord()if @get 'isValid'
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView