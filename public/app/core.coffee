###
 * core
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:32
###

define ->
  Ember.Handlebars.registerBoundHelper 'moment', (value, options)->
    new Handlebars.SafeString(moment(value).format(options.hash.format))

  TournamentGrid = Em.Namespace.create
  App = Em.Application.create
    VERSION: '0.1'
    autoinit: false
  App.deferReadiness()
  window.TournamentGrid = TournamentGrid
  window.App = App

  DS.RecordArray.reopen
    onLoad: (callback)->
      if @get 'isLoaded'
        callback this
      else
        that = @
        isLoadedFn = ->
          if that.get 'isLoaded'
            that.removeObserver 'isLoaded', isLoadedFn
            callback that
      @addObserver 'isLoaded', isLoadedFn
      @

  DS.RESTAdapter.configure 'plurals',
    country: 'countries'
    match: 'matches'

  App.store = DS.Store.create
    revision: 11
    adapter: DS.RESTAdapter.create
      bulkCommit: yes
      namespace: 'api'

  App.store.adapter.serializer.primaryKey = -> '_id'