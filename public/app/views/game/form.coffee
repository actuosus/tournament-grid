###
 * form
 * @author: actuosus
 * Date: 15/03/2013
 * Time: 19:37
###

define [
  'ehbs!game/form'
  'cs!../../models/game'
  'cs!../form'
], (template)->
#  Em.TEMPLATES.gameForm = Em.Handlebars.compile template

  App.GameForm = App.FormView.extend
    classNames: ['game-form']
    templateName: 'game/form'
    countrySelectViewBinding: 'childViews.firstObject'

    title: null
    link: null

    isValid: (->
      @get('element').checkValidity()
    ).property()

    didCreate: Em.K

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

      match = @get 'match'

      transaction = App.store.transaction()
      game = transaction.createRecord(App.Game)
#      game = App.Game.createRecord()
      game.set 'match', match
      game.set 'title', @$('.title').val()
      game.set 'link', @$('.link').val()
      game.on 'didCreate', => @didCreate game
      game.on 'becameError', => game.destroy()
      match.get('games').pushObject(game)
      transaction.commit()

    deleteRecord: ->
      @$('.delete-btn').attr('disabled', 'disabled')
      content = @get 'content'
      if content
        content.deleteRecord()

    submit: (event)->
      event.preventDefault()
      @createRecord()if @get 'isValid'

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()if @get 'isValid'
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView