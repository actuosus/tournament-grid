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
    firstName: (-> Faker.Name.firstName()).property().volatile()
    lastName: (-> Faker.Name.lastName()).property().volatile()
    middleName: ''
    country: null
    isCaptain: null

    didCreate: Em.K

    didInserElement: ->
      @set 'country', App.Country.find({name: 'Россия'})

    focus: ->
      @$('.nickname').focus()

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

#      country = @get 'country'
      country = @get('countrySelectView.autocompleteTextFieldView.selection')
      team = @get 'entrant'
      transaction = App.store.transaction()
      player = transaction.createRecord(App.Player)
      player.set 'country', country
      player.set 'team', team
      player.set 'nickname', @$('.nickname').val()
      player.set 'firstName', @$('.first-name').val()
      player.set 'middleName', @$('.middle-name').val()
      player.set 'lastName', @$('.last-name').val()
      player.on 'didCreate', => @didCreate player
      player.on 'becameError', =>
        console.log arguments
        player.destroy()
      transaction.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView