###
 * router
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 09:10
###

define [
  'cs!./core'
  'cs!./models'
  'cs!./views'
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
      App.set 'isEditingMode', yes
      
      console.log 'Setting up report controller'
      App.set 'router', @router
      App.set 'report', model
      App.overrideAdapterAjax model
#      window.stageView.set('controller', controller)
      @transitionTo 'stages'

    renderTemplate: (controller, model)->
      console.log controller,
      reportEntrants = @controllerFor 'reportEntrants'
      reportEntrants.set 'content', model.get('teamRefs')
      if model.get('match_type') is 'team'
        @render 'LineupContainer',
          outlet: 'lineup',
          into: 'application'
          controller: 'reportEntrants'
    model: -> App.Report.find window.grid.reportId

  App.StagesRoute = Em.Route.extend
    model: ->
      console.log 'App.report', App.get('report')
      App.get('report.stages')

    setupController: (controller, model)->
      console.log 'Setting up stages controller'
      console.log 'stages', controller, model
      controller.set 'model', App.get('report.stages')
    renderTemplate: (controller, model)->
      console.log arguments
      @render()

      @render 'StagesContainer',
        outlet: 'stages',
        into: 'application'
        controller: 'stages'

  App.StageRoute = Ember.Route.extend
    setupController: (controller, model)->
#      window.stageView.set('controller', controller)
#      window.stageView.set('currentStage', model)
#      window.stageView.get('currentStage').addObserver 'data', window.stageView, window.stageView.currentStageDidLoad

    model: (params)-> App.Stage.find params.stage_id