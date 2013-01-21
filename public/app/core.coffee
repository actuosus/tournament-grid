###
 * core
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:32
###

define ->
  TournamentGrid = Em.Namespace.create
  App = Em.Application.create
    VERSION: '0.1'
    autoinit: false
  window.TournamentGrid = TournamentGrid
  window.App = App

  App.store = DS.Store.create
    revision: 10
    adapter: DS.RESTAdapter.create
      bulkCommit: yes
  App.store.adapter.serializer.primaryKey = -> '_id'