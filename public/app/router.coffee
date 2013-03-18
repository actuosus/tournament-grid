###
 * router
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 09:10
###

define ['cs!core'], ->
  App.Router.map (match)->
    @route 'demo'
#  App.Router = Ember.Router.extend
#    enableLogging: yes
#    location: 'history'
#    root: Ember.Route.extend
#      index: Ember.Route.extend
#        route: '/'
#        redirectsTo: 'demo'
#
#      demo: Ember.Route.extend
#        route: '/index'
#        enter: ->
#          $('.subhead h1').text('AdName')

  App.DemoRoute = Ember.Route.extend
    setupController: (controller)->
      # Set the IndexController's `title`
      controller.set 'title', "My App"