###
 * form
 * @author: actuosus
 * @fileOverview
 * Date: 03/03/2013
 * Time: 20:08
###

define [
  'text!../../templates/player/form.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.playerForm = Em.Handlebars.compile template
  App.PlayerForm = Em.View.extend
    tagName: 'form'
    classNames: ['player-form']
    templateName: 'playerForm'
    countrySelectViewBinding: 'childViews.firstObject'

    nicknameBinding: 'value'
    firstName: null
    lastName: null
    middleName: ''
    country: null
    isCaptain: no

    canBeCaptain: (->
      console.log 'hasCaptain',@get('entrant.hasCaptain')
      !@get('entrant.hasCaptain')
    ).property('entrant.hasCaptain')

    isCaptainChanged: (->
      console.log 'isCaptain', @get 'isCaptain'
    ).observes('isCaptain')

    didCreate: Em.K

    didInserElement: ->
      @set 'country', App.Country.find({name: 'Россия'})

    focus: ->
      @$('.nickname').focus()

    isValid: (->
      @get('element').checkValidity()
    ).property()

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

#      country = @get 'country'
      country = @get('countrySelectView.autocompleteTextFieldView.selection')
      team = @get 'entrant'
      players = @get 'entrant.players'
      report = App.get('report')
      transaction = App.store.transaction()
      player = transaction.createRecord(App.Player)
      player.set 'country', country
      player.set 'nickname', @$('.nickname').val()
      player.set 'firstName', @$('.first-name').val()
      player.set 'middleName', @$('.middle-name').val()
      player.set 'lastName', @$('.last-name').val()
      player.set 'isCaptain', @get 'isCaptain'

      player.set 'report', report
#      player.set 'team', team
      players.addObject player

      player.on 'didCreate', => @didCreate player
      player.on 'becameError', =>
        console.log arguments
        player.destroy()
      transaction.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()if @get 'isValid'

    click: (event)->
      event.stopPropagation()
      if $(event.target).hasClass('save-btn')
        @createRecord()if @get 'isValid'
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView