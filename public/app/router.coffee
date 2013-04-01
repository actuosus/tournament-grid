###
 * router
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 09:10
###

define ['cs!./core', 'cs!./models/stage'], ->
#  App.Router.map ->
#    @resource 'stages', ->
#    @resource 'stage', path: '/stages/:stage_id'
#
#  App.StagesRoute = Ember.Route.extend
#    model: ()-> App.Stage.all()
#    renderTemplate: ()->
#      controller = @controllerFor('stage')
#      console.log controller
#      @render 'stages'
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
