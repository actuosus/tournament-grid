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
#      @route 'new'
      @resource 'stage', path: '/:stage_id'
#        @resource 'matches', ->
#          @route 'new'
#
#  App.IndexRoute = Ember.Route.extend
#    redirect: -> @transitionTo 'stages'
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
#
#  App.StageRoute = Ember.Route.extend
#    setupController: (controller, model)->
#      console.log controller, model
#      controller.set 'content', model
##    renderTemplate: ()->
##      controller = @controllerFor('stage')
##      console.log controller
##      @render 'stage'
#    model: (params)->
#      console.log 'Model for', params
#      App.Stage.find params.stage_id
