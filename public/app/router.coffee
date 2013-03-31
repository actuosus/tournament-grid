###
 * router
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 09:10
###

define ['cs!./core', 'cs!./models/stage'], ->
  App.Router.map ->
    @resource 'stage', path: '/stage/:stage_id', ->
      @route 'new'
#
#  App.StageRoute = Ember.Route.extend
#    model: (params)->
#      App.Stage.find params.stage_id
