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
    @route 'index', path: '*.'
    @resource 'stages', ->
      @route 'new'
      @resource 'stage', path: '/:stage_id'

  App.ApplicationRoute = Em.Route.extend
#    afterModel: -> @transitionTo 'stages'
    setupController: (controller, model)->
#      @_super controller, model
      # Preloading countries
      console.debug 'Preloading countries…'
      App.countries = App.Country.find()

#      App.set 'isEditingMode', yes
      App.set 'router', @router
      App.set 'report', model
      App.overrideAdapterAjax model

      @controllerFor('stages').set 'model', App.get 'report.stages'
#      @transitionTo 'stages'

    renderTemplate: (controller, model)->
      @render()

      @render 'StagesContainer',
        outlet: 'stages',
        into: 'application'
        controller: 'stages'

      reportEntrants = @controllerFor 'reportEntrants'
      reportEntrants.set 'content', model.get('teamRefs')
      if model.get('match_type') is 'team'
        @render 'LineupContainer',
          outlet: 'lineup',
          into: 'application'
          controller: 'reportEntrants'

    model: (params)->
      App.store.findById App.Report, window.grid.reportId

    events: error: (error, transition)-> @transitionTo 'error'

  App.ErrorRoute = Em.Route.extend
    renderTemplate: (controller, model)->
      @render 'NoReport',
        into: 'application'

  App.StageRoute = Ember.Route.extend
    setupController: (controller, model)->
      console.debug 'Setting up stage route'
#      window.stageView.set('controller', controller)
#      window.stageView.set('currentStage', model)
#      window.stageView.get('currentStage').addObserver 'data', window.stageView, window.stageView.currentStageDidLoad

    model: (params)-> App.Stage.find params.stage_id