###
 * form
 * @author: actuosus
 * Date: 15/03/2013
 * Time: 19:37
###

define [
  'text!templates/game/form.handlebars'
  'cs!models/game'
], (template)->
  Em.TEMPLATES.gameForm = Em.Handlebars.compile template
  App.GameForm = Em.View.extend
    tagName: 'form'
    classNames: ['game-form']
    templateName: 'gameForm'
    countrySelectViewBinding: 'childViews.firstObject'

    title: (-> Faker.Company.catchPhrase() ).property().volatile()
    link: (-> 'http://' + Faker.Internet.domainName() + '/').property().volatile()

    didCreate: Em.K

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

      match = @get 'match'

      transaction = App.store.transaction()
#      game = transaction.createRecord(App.Game)
      game = App.Game.createRecord()
      game.set 'match', match
      game.set 'link', @$('.link').val()
      game.on 'didCreate', => @didCreate
      game.on 'becameError', =>
        console.log arguments
        game.destroy()
      match.get('games').pushObject(game)
#      transaction.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView