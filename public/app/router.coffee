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
    @route 'index', path: ''
    @route 'index', path: '*.'
    @resource 'stages', ->
      @route 'new'
      @resource 'stage', path: '/:stage_id'

  App.ApplicationRoute = Em.Route.extend
    setupController: (controller, model)->
      # Preloading countries
      console.debug 'Preloading countries…' if window.DEBUG
      App.countries = App.Country.find()

      App.set 'countriesController.content', App.countries

      App.set 'router', @router
      App.set 'report', model
      App.overrideAdapterAjax model

      @controllerFor('stages').set 'model', App.get 'report.stages'

    renderTemplate: (controller, model)->
      $(App.get('rootElement')).empty()

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

    model: (params)-> App.Stage.find params.stage_id