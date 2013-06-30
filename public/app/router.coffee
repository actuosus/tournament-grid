###
 * router
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 09:10
###

define [
  'cs!./core'
  'cs!./models/index'
  'cs!./views/index'
], ->
  App.Router.map ->
    @resource 'report', {path: '/'}, ->
      @resource 'stages', ->
        @route 'new'
        @resource 'stage', path: '/:stage_id'

  App.IndexRoute = Em.Route.extend
    redirect: -> @transitionTo 'report'

  App.ReportRoute = Em.Route.extend
    setupController: (controller, model)->
      # Preloading countries
      console.debug 'Preloading countries…'
      App.countries = App.Country.find()

#      App.set 'isEditingMode', yes
      App.set 'router', @router
      App.set 'report', model
      App.overrideAdapterAjax model
      @transitionTo 'stages'

    renderTemplate: (controller, model)->
      reportEntrants = @controllerFor 'reportEntrants'
      reportEntrants.set 'content', model.get('teamRefs')
      if model.get('match_type') is 'team'
        @render 'LineupContainer',
          outlet: 'lineup',
          into: 'application'
          controller: 'reportEntrants'
    model: (params)->
      App.store.findById App.Report, window.grid.reportId

  App.StagesRoute = Em.Route.extend
    model: -> App.get 'report.stages'

    setupController: (controller, model)->
      controller.set 'model', App.get('report.stages')

    renderTemplate: (controller, model)->
      @render()

      @render 'StagesContainer',
        outlet: 'stages',
        into: 'application'
        controller: 'stages'

  App.StageRoute = Ember.Route.extend
    setupController: (controller, model)->
      console.debug 'Setting up stage route'
#      window.stageView.set('controller', controller)
#      window.stageView.set('currentStage', model)
#      window.stageView.get('currentStage').addObserver 'data', window.stageView, window.stageView.currentStageDidLoad

    model: (params)-> App.Stage.find params.stage_id