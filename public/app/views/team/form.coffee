###
 * form
 * @author: actuosus
 * @fileOverview Team form view.
 * Date: 28/02/2013
 * Time: 22:34
###

define [
  'text!../../templates/team/form.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.teamForm = Em.Handlebars.compile template
  App.TeamForm = Em.View.extend
    tagName: 'form'
    classNames: ['team-form']
    templateName: 'teamForm'
    countrySelectViewBinding: 'childViews.firstObject'

    nameBinding: 'value'

    didCreate: Em.K

    focus: ->
      @$('.name').focus()

    createRecord: ->
      country = @get 'countrySelectView.selection'
      transaction = App.store.transaction()
      team = transaction.createRecord(App.Team)
      team.set 'country', country
      team.set 'name', @$('.name').val()
      team.on 'didCreate', => @didCreate team
      team.on 'becameError', =>
        console.log arguments
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