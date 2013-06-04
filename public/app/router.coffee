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

  App.ApplicationRoute = Em.Route.extend
    setupController: (controller, model)->
      window.stageView.set('controller', controller)

  App.StageRoute = Ember.Route.extend
    setupController: (controller, model)->
      window.stageView.set('controller', controller)
      window.stageView.set('currentStage', model)
      window.stageView.get('currentStage').addObserver 'data', window.stageView, window.stageView.currentStageDidLoad

    model: (params)-> App.Stage.find params.stage_id