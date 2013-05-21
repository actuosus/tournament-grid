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
    @resource 'stages', ->
      @route 'new'
      @resource 'stage', path: '/:stage_id'
#        @resource 'matches', ->
#          @route 'new'
#
#  App.IndexRoute = Ember.Route.extend
#    redirect: -> @transitionTo 'stage', App.get('report.stages.firstObject')
#
##  App.ReportRoute = Ember.Route.extend
#
#  App.StagesRoute = Ember.Route.extend
#    model: ->
#      App.Stage.find({report_id: window.currentReportId})
##    renderTemplate: ->
##      controller = @controllerFor('stage')
##      console.log controller
##      @render 'stages'

  App.ApplicationRoute = Em.Route.extend
    setupController: (controller, model)->
      window.stageView.set('controller', controller)

#  App.StagesNewRoute = Em.Route.extend
#    setupController: (controller, model)->
#      window.stageView.set('controller', controller)

  App.StageRoute = Ember.Route.extend
    setupController: (controller, model)->
      window.stageView.set('controller', controller)
      window.stageView.set('currentStage', model)
      window.stageView.get('currentStage').addObserver 'data', window.stageView, window.stageView.currentStageDidLoad

    model: (params)->
      console.log 'Model for', params
      App.Stage.find params.stage_id
