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
    @resource 'stages', ->
      @route 'new'
      @resource 'stage', path: '/:stage_id'

  App.ErrorRoute = Em.Route.extend
    renderTemplate: (controller, model)->
      @render 'NoReport',
        into: 'application'

  App.ApplicationRoute = Em.Route.extend
    model: (params)-> @store.find 'report', window.grid.reportId

    afterModel: (model)->
      console.debug 'App.ApplicationRoute:afterModel'
      @store.findAll('country').then (countries)->
        App.set 'countriesController.model', countries
        App.set 'countries', countries
      App.set 'store', @store
      App.set 'router', @router
      App.set 'report', model
      App.overrideAdapterAjax model

    setupController: (controller, model)->
#      @controllerFor('stages').set 'model', App.get 'report.stages'
#      @transitionTo 'stage', App.get 'report.stages.firstObject'
      reportEntrants = @controllerFor 'reportEntrants'
      reportEntrants.set 'content', model.get('teamRefs')

    renderTemplate: (controller, model)->
      $(App.get('rootElement')).empty()

      @render()

      @render 'StagesContainer',
        outlet: 'stages'
        into: 'application'
        controller: 'stages'
        model: model.get('stages')

      if model.get('match_type') is 'team'
        @render 'LineupContainer',
          outlet: 'lineup',
          into: 'application'
          controller: 'reportEntrants'

    actions:
      error: (error, transition)->
        @transitionTo 'error'
        throw error

  App.IndexRoute = Em.Route.extend
    afterModel: -> @transitionTo 'stage', App.get 'report.stages.firstObject'

#  App.ApplicationRoute = Em.Route.extend
#    renderTemplate: (controller, model)->
#      $(App.get('rootElement')).empty()
#      @render()
#
#  App.IndexRoute = Em.Route.extend
#    model: (params)->
#      url = "#{App.config.local.api.host}/#{App.config.local.api.namespace}/reports/#{window.grid.reportId}/dump"
#      Em.$.getJSON url
#
#    renderTemplate: (controller, model)->
#      if model and model.dump
#        @render 'Dump',
#          outlet: 'stages'
#          into: 'application'
#          model: model.dump
#
#    actions:
#      error: (error, transition)->
#        @transitionTo 'error'
#        throw error

  App.StagesRoute = Em.Route.extend
    model: (params)-> App.report.get('stages')

  App.StagesIndexRoute = Em.Route.extend
    model: (params)-> App.report.get('stages')

  App.StageRoute = Em.Route.extend
    setupController: (controller, model)->
      @controllerFor('stages').set('selection', Em.Controller.create({content: model}))
      # @container.lookup('view:stage_tabs').set 'selection', Em.Controller.create({content: model})
    model: (params)-> @store.find 'stage', params.stage_id