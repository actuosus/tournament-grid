###
 * form
 * @author: actuosus
 * @fileOverview
 * Date: 03/03/2013
 * Time: 20:08
###

define [
  'text!templates/player/form.handlebars'
], (template)->
  Em.TEMPLATES.playerForm = Em.Handlebars.compile template
  App.PlayerForm = Em.View.extend
    tagName: 'form'
    classNames: ['player-form']
    templateName: 'playerForm'
    countrySelectViewBinding: 'childViews.firstObject'

    nickname: (-> Faker.Company.companyName()).property().volatile()
    firstName: (-> Faker.Name.firstName()).property().volatile()
    lastName: (-> Faker.Name.lastName()).property().volatile()
    middleName: ''

    didCreate: Em.K

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

      country = @get 'countrySelectView.selection'
      team = @get 'entrant'
      player = App.Player.createRecord
        country: country
        team: team
        nickname: @$('.nickname').val()
        firstName: @$('.first-name').val()
        middleName: @$('.middle-name').val()
        lastName: @$('.last-name').val()
      player.on 'didCreate', => @didCreate player
      player.on 'becameError', =>
        console.log arguments
        player.destroy()
      App.store.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView