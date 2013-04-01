###
 * application
 * @author: actuosus
 * @fileOverview Application initialization.
 * Date: 21/01/2013
 * Time: 07:31
###

define [
  'jquery'
  'Faker'
  'ember'
  'ember-data'

  'cs!./core'

  'cs!./router'
  'cs!./controllers'
  'cs!./views'
  'cs!./models'
  'cs!./fixtures'

  'text!./templates/lineup_grid_item.handlebars'

  'cs!./mixins/translatable'
  'cs!./mixins/collapsable'
  'cs!./translators/yandex'

], ()->

#  App.ApplicationController = Em.Controller.extend()
#  App.ApplicationView = Em.View.extend
#    templateName : 'application'

  App.isEditingMode = no

  $(document.body).keydown (event)->
    if event.ctrlKey
      if event.shiftKey
        switch event.keyCode
          when 69 # e
            App.set 'isEditingMode', not App.get('isEditingMode')

  App.ready = ->
    App.set 'report', App.Report.find window.currentReportId

    App.set 'entrantsController', App.EntrantsController.create()
    App.set 'countriesController', App.CountriesController.create()
    App.set 'teamsController', App.TeamsController.create()
    App.set 'playersController', App.PlayersController.create()

    window.teamsController = teamsController

    stageView = App.StageTabsView.create()
    window.stageView = stageView

    # Preloading countries
    App.countries = App.Country.find()

    App.anotherCountriesController = Em.ArrayController.create content: []

    stageSelectorContainerView = App.NamedContainerView.create
      title: '_tournament_results_table'.loc()
      contentView: stageView
      countriesIsUpdating: (controller)->
        console.log 'countriesIsUpdating', controller.get('content.isUpdating'), controller.get('content.isLoaded')
        unless controller.get('content.isUpdating')
          @set 'loaderView.isVisible', no
          @set 'statusTextView.value', ''
        else
          @set 'loaderView.isVisible', yes
          @set 'statusTextView.value', 'Countries loading…'
    App.anotherCountriesController.addObserver(
                    'content.isUpdating',
                    stageSelectorContainerView,
                    stageSelectorContainerView.countriesIsUpdating
                  )

    App.anotherCountriesController.set('content', App.Country.find())

    stageSelectorContainerView.appendTo '#content'

    teamsController = Em.ArrayController.create
      contentBinding: 'App.report.entrants'
      sortProperties: ['gamesPlayed']
      editingModeChanged: ->
        content = @get 'content'
        if App.get('isEditingMode')
          content.createRecord({proxy: true, report: App.get('report')})
        else
          proxy = content.find (item)-> item if item.get('proxy')
          content.removeObject(proxy) if proxy
    App.addObserver 'isEditingMode', teamsController, teamsController.editingModeChanged

    reportEntrants = App.EntrantsController.create content: App.report.get 'entrants'
    lineupView = App.LineupView.create
      controller: reportEntrants
      contentBinding: 'controller.arrangedContent'

    window.lineupView = lineupView

    lineupContainerView = App.LineupContainerView.create contentView: lineupView

    $('.link_pencil').click (event)->
      event.preventDefault()
      App.set 'isEditingMode', not App.get('isEditingMode')

      if lineupContainerView?.$()
        $(document.body).scrollTo(lineupContainerView.$(), 500, {offset: {top: -18}})
      else if stageSelectorContainerView?.$()
        $(document.body).scrollTo(stageSelectorContainerView.$(), 500, {offset: {top: -18}})

    App.report.didLoad = ->
      stageView.set('content', App.report.get('stages'))
      if App.report?.get('match_type') is 'team'
        lineupContainerView.appendTo '#content'

#    matches = App.store.find(App.Match, {}).onLoad (ra)->
#      ra.forEach (match)->
#        team1 = match.get('team1')
#        team2 = match.get('team2')
#        team1?.set('gamesPlayed', (team1.gamesPlayed + 1) || 1)
#        team2?.set('gamesPlayed', (team2.gamesPlayed + 1) || 1)
#        if match.get('team1_points') > match.get('team2_points')
#          team1?.set('wins', (team1.wins + 1) || 1)
#          team2?.set('loses', (team2.loses + 1) || 1)
#        else if match.get('team1_points') == match.get('team2_points')
#          team1?.set('draws', (team1.draws + 1) || 1)
#          team2?.set('draws', (team2.draws + 1) || 1)
#        else
#          team2?.set('wins', (team2.wins + 1) || 1)
#          team1?.set('loses', (team1.loses + 1) || 1)

#    App.NamedContainerView.create(
#      title: 'Tester'
#      contentView: App.TesterView.create()
#    ).appendTo('#content')

    App.peroids = Em.ArrayController.create
      content: [
        Em.Object.create name:'Период', id: 'period'
        Em.Object.create name:'Дата', id: 'date'
        Em.Object.create name:'Сегодня', id: 'today'
        Em.Object.create name:'Вчера', id: 'yesterday'
        Em.Object.create name:'Неделя', id: 'week'
        Em.Object.create name:'Месяц', id: 'month'
      ]

    App.matchTypes = Em.ArrayController.create
      content: [
        Em.Object.create name:'_period'.loc(), id: 'period'
        Em.Object.create name:'_date'.loc(), id: 'date'
        Em.Object.create name:'_today'.loc(), id: 'today'
        Em.Object.create name:'_yesterday'.loc(), id: 'yesterday'
        Em.Object.create name:'_week'.loc(), id: 'week'
        Em.Object.create name:'_month'.loc(), id: 'month'
      ]

    App.visualTypes = Em.ArrayController.create
      content: [
        Em.Object.create name:'_grid'.loc(), id: 'grid'
        Em.Object.create name:'_group'.loc(), id: 'group'
        Em.Object.create name:'_matrix'.loc(), id: 'matrix'
        Em.Object.create name:'_team'.loc(), id: 'team'
      ]

    App.entrantsController.set 'content', App.Team.find()

#  $ -> App.advanceReadiness()
  App.ready()


