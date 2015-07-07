###
 * form
 * @author: actuosus
 * @fileOverview Team form view.
 * Date: 28/02/2013
 * Time: 22:34
###

define [
  'ehbs!/team/form'
  'cs!../../core'
  'cs!../form'
], ->
  App.TeamForm = App.FormView.extend
    classNames: ['team-form']
    templateName: 'team/form'
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
      report = App.get('report')
      team = App.store.createRecord('team', {
        country: country,
        name: @$('.name').val(),
        report: report
      })
      team.on 'didCreate', => @didCreate team
      team.on 'becameError', => @$('.save-btn').removeAttr('disabled')
      team.save()

    submit: (event)->
      event.preventDefault()
      @createRecord()if @get 'isValid'

    click: (event)->
      event.preventDefault()
      if $(event.target).hasClass('save-btn')
        @createRecord()if @get 'isValid'
      if $(event.target).hasClass('cancel-btn')
        @popupView.hide() if @popupView