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
  'cs!../form'
], (template)->
  Em.TEMPLATES.teamForm = Em.Handlebars.compile template
  App.TeamForm = App.FormView.extend
    classNames: ['team-form']
    templateName: 'teamForm'
    countrySelectViewBinding: 'childViews.firstObject'

    nameBinding: 'value'

    didCreate: Em.K

    focus: ->
      @$('.name').focus()

    isValid: (->
      @get('element').checkValidity()
    ).property()

    createRecord: ->
      @$('.save-btn').attr('disabled', 'disabled')

      country = @get 'countrySelectView.value'
      transaction = App.store.transaction()
      report = App.get('report')
      team = transaction.createRecord(App.Team)
      team.set 'country', country
      team.set 'name', @$('.name').val()
      team.set 'report', report
      team.on 'didCreate', => @didCreate team
      team.on 'becameError', => @$('.save-btn').removeAttattr('disabled')
      transaction.commit()

    submit: (event)->
      event.preventDefault()
      @createRecord()if @get 'isValid'

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()if @get 'isValid'
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView