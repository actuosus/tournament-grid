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

  'cs!./controllers'
  'cs!./views'
  'cs!./models'
  'cs!./fixtures'

  'cs!./router'

  'text!./templates/lineup_grid_item.handlebars'

  'cs!./mixins/translatable'
  'cs!./mixins/collapsable'
  'cs!./translators/yandex'

#  'cs!./tree_test'

  'cs!lib/node'

], ()->

#  App.ApplicationController = Em.Controller.extend()
#  App.ApplicationView = Em.View.extend
#    templateName : 'application'

  App.set 'isEditingMode', yes

  $(document.body).keydown (event)->
#    console.log event.keyCode
    if event.ctrlKey
      if event.shiftKey
        switch event.keyCode
          when 65 # a
            App.toggleConfig()
          when 69 # e
            App.set 'isEditingMode', not App.get('isEditingMode')
          when 90 # z
            History.undo()

  App.ready = ->
    $('#content').empty()

    Em.run ->
    App.set 'report', App.Report.find window.currentReportId
#
    App.set 'entrantsController', App.EntrantsController.create()
    App.set 'countriesController', App.CountriesController.create()
    App.set 'teamsController', App.TeamsController.create()
    App.set 'playersController', App.PlayersController.create()

#    App.socketController = App.SocketController.create()
#    App.socketController.connect()
#
#    window.teamsController = teamsController
#
    stageTabsView = App.StageTabsView.create()
    window.stageView = stageTabsView
#
#    # Preloading countries
    App.countries = App.Country.find()
#
#    App.anotherCountriesController = Em.ArrayController.create content: []
#
    stageSelectorContainerView = App.NamedContainerView.create
      title: '_tournament_results_table'.loc()
      contentView: stageTabsView
#
#    teamsController = Em.ArrayController.create
#      contentBinding: 'App.report.entrants'
#      sortProperties: ['gamesPlayed']
#      editingModeChanged: ->
#        content = @get 'content'
#        if App.get('isEditingMode')
#          content.createRecord({proxy: true, report: App.get('report')})
#        else
#          proxy = content.find (item)-> item if item.get('proxy')
#          content.removeObject(proxy) if proxy
#    App.addObserver 'isEditingMode', teamsController, teamsController.editingModeChanged
#

#
#    $('.link_pencil').click (event)->
#      event.preventDefault()
#      App.set 'isEditingMode', not App.get('isEditingMode')
#
#      if lineupContainerView?.$()
#        $(document.body).scrollTo(lineupContainerView.$(), 500, {offset: {top: -18}})
#      else if stageSelectorContainerView?.$()
#        $(document.body).scrollTo(stageSelectorContainerView.$(), 500, {offset: {top: -18}})

    App.get('report').didLoad = ->
      report = App.get 'report'
      stageTabsView.set 'content', report.get('stages')
      App.racesController.set 'content', report.get('races')

      if report?.get('match_type') is 'team'
        reportEntrants = App.ReportEntrantsController.create
          contentBinding: 'App.report.teamRefs'
#        reportEntrants = App.EntrantsController.create
#          sortProperties: ['team.name']
#          contentBinding: 'App.report.teamRefs'
        lineupView = App.LineupView.create
          classNames: ['team-lineup-grid']
          controller: reportEntrants
          contentBinding: 'controller.arrangedContent'
#          contentBinding: 'App.report.teamRefs'

        window.lineupView = lineupView
        lineupContainerView = App.LineupContainerView.create contentView: lineupView
        lineupContainerView.appendTo '#content'

        unless window.stageView.get('currentStage')
          window.stageView.get('controller')?.transitionTo 'stage', App.get('report.stages.firstObject')
#          window.stageView.set('currentStage', report.get('stages.firstObject'))
#          window.stageView.get('currentStage').addObserver 'data', window.stageView, window.stageView.currentStageDidLoad

#      App.store.adapter.findMany = (store, type, ids, owner)->
#        root = @rootForType(type)
#        ids = @serializeIds(ids)
#
#        data = {ids: ids}
#        data.report_id = owner.get('id') if App.Report.detectInstance(owner)
#
#        @ajax @buildURL(root), "GET", {
#          data: data,
#          success: (json)-> Ember.run @, -> @didFindMany(store, type, json)
#        }
      App.store.adapter.ajax = (url, type, hash)->
        hash.url = url
        hash.type = type
        hash.dataType = 'json'
        hash.contentType = 'application/json; charset=utf-8'
        hash.context = @

        if hash.data
          if type isnt 'GET'
            hash.url += "?report_id=#{report.get 'id'}"
            hash.data = JSON.stringify hash.data
          else
            hash.data.report_id = report.get 'id'
        else
          hash.url += "?report_id=#{report.get 'id'}"

        jQuery.ajax hash


    stageSelectorContainerView.appendTo '#content'
#
#    ###
#      Кодировать и визуализировать состояние матча (сохранение и редактирование)
#
#      Подтверждать сохранение и закрытие каждого матча
#      В течении получаса (суток) редактирование матча возможно
#
#      Группу тоже можно и нужно закрывать
#
#      При клике на участника группы он маркируется
#
#    ###
#
#    App.NamedContainerView.create(
#      title: 'Tester'
#      contentView: App.TesterView.create()
#    ).appendTo('#content')

#    App.NamedContainerView.create(
#      title: '3D'
#      contentView: App.Tournament3DGridView.create(content: App.get('report.stages'))
#    ).appendTo('#content')

#    App.entrantsNumber = 8

#    window.newTournamentGridView = App.NewTournamentGridView.create
#      entrantsNumberBinding: 'App.entrantsNumber'
#    App.NamedContainerView.create(
#      title: 'Tournament grid'
#      contentView: window.newTournamentGridView
#    ).appendTo('#content')
#
#    window.newTournamentSingleGridView = App.NewTournamentGridView.create
#      entrantsNumberBinding: 'App.entrantsNumber'
#    App.NamedContainerView.create(
#      title: 'Single grid'
#      contentView: window.newTournamentSingleGridView
#    ).appendTo('#content')
#
#    window.newTournamentDoubleGridView = App.NewDoubleTournamentGridView.create
#      entrantsNumberBinding: 'App.entrantsNumber'
#    App.NamedContainerView.create(
#      title: 'Double grid'
#      contentView: window.newTournamentDoubleGridView
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
#        Em.Object.create name:'_grid'.loc(), id: 'grid'
        Em.Object.create name:'_single'.loc(), id: 'single'
        Em.Object.create name:'_double'.loc(), id: 'double'
        Em.Object.create name:'_group'.loc(), id: 'group'
        Em.Object.create name:'_matrix'.loc(), id: 'matrix'
        Em.Object.create name:'_team'.loc(), id: 'team'
      ]

    App.racesController = Em.ArrayController.create
      content: [
        Em.Object.create name: '_zerg'.loc(), id: 'zerg'
        Em.Object.create name: '_protoss'.loc(), id: 'protos'
        Em.Object.create name: '_terrain'.loc(), id: 'terrain'
      ]
      all: ->
        @set 'content.isLoaded', yes
      search: (options)->
        result = @get('content').filter (item, idx)->
          regexp = new RegExp(options.name, 'i')
          if item.get('name')?.match regexp
            return yes
          if item.get('__name')?.match regexp
            return yes
          if item.get('englishName')?.match regexp
            return yes
        @set 'content.isLoaded', yes
      menuItemViewClass: Em.View.extend
        classNames: ['menu-item']
        classNameBindings: ['isSelected']
        template: Em.Handlebars.compile(
#          '<i {{bindAttr class=":country-flag-icon view.content.flagClassName"}}></i>'+
          '{{view.content.name}}')
        mouseDown: (event)->
          event.stopPropagation()

        click: (event)->
          event.preventDefault()
          event.stopPropagation()
          @get('parentView').click(event)
          @set 'parentView.selection', @get 'content'
          @set 'parentView.value', @get 'content'
          @set 'parentView.isVisible', no

#  rootNode = App.Node.create(content: 'root')
#  rootNode.set('left', App.Node.create(
#    content: 'left1',
#    left: App.Node.create(content: 'left2'),
#    right: App.Node.create(content: 'right2'))
#  )
#  rootNode.set('right', App.Node.create(content: 'right1'))
#
#  App.MatchTreeItemView = App.TreeItemView.extend
#    treeItemViewClass: (->
#      App.MatchGridItemView.extend
#        classNames: ['tree-item-view-content'],
#        contentBinding: 'parentView.content'
#        contentIndexBinding: 'parentView.contentIndex'
#    ).property()
#
#  treeView = App.TreeView.create content: [rootNode]
##  treeView.appendTo '#content'
#
#  App.NamedContainerView.create(
#    title: 'Tree'
#    contentView: treeView
#  ).appendTo('#content')


