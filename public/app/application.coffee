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

  App.set 'isEditingMode', no

  $(document.body).keydown (event)->
    console.log event.keyCode
    if event.ctrlKey
      if event.shiftKey
        switch event.keyCode
          when 69 # e
            App.set 'isEditingMode', not App.get('isEditingMode')
          when 90 # z
            History.undo()

  App.ready = ->

    App.set 'report', App.Report.find window.currentReportId
#
    App.set 'entrantsController', App.EntrantsController.create()
    App.set 'countriesController', App.CountriesController.create()
    App.set 'teamsController', App.TeamsController.create()
    App.set 'playersController', App.PlayersController.create()
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
      countriesIsUpdating: (controller)->
        console.log 'countriesIsUpdating', controller.get('content.isUpdating'), controller.get('content.isLoaded')
        unless controller.get('content.isUpdating')
          @set 'loaderView.isVisible', no
          @set 'statusTextView.value', ''
        else
          @set 'loaderView.isVisible', yes
          @set 'statusTextView.value', 'Countries loading…'
#    App.anotherCountriesController.addObserver(
#                    'content.isUpdating',
#                    stageSelectorContainerView,
#                    stageSelectorContainerView.countriesIsUpdating
#                  )
#
#    App.anotherCountriesController.set('content', App.Country.find())
#
#
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
    reportEntrants = App.EntrantsController.create contentBinding: 'App.report.entrants'
    lineupView = App.LineupView.create
      classNames: ['team-lineup-grid']
      controller: reportEntrants
      contentBinding: 'controller.arrangedContent'
#
    window.lineupView = lineupView
#
    lineupContainerView = App.LineupContainerView.create contentView: lineupView
#
#    $('.link_pencil').click (event)->
#      event.preventDefault()
#      App.set 'isEditingMode', not App.get('isEditingMode')
#
#      if lineupContainerView?.$()
#        $(document.body).scrollTo(lineupContainerView.$(), 500, {offset: {top: -18}})
#      else if stageSelectorContainerView?.$()
#        $(document.body).scrollTo(stageSelectorContainerView.$(), 500, {offset: {top: -18}})

    initer = Em.Object.create
      reportMatchTypeDefined: ->
        report = App.get('report')
        if report?.get('match_type') is 'team'
          lineupContainerView.appendTo '#content'

    App.report.addObserver 'match_type', initer, initer.reportMatchTypeDefined
#
    App.get('report').didLoad = ->
      report = App.get 'report'
      stageTabsView.set 'content', report.get('stages')

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
    App.NamedContainerView.create(
      title: 'Tester'
      contentView: App.TesterView.create()
    ).appendTo('#content')

#    App.NamedContainerView.create(
#      title: '3D'
#      contentView: App.Tournament3DGridView.create(content: App.get('report.stages'))
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

  $ -> App.advanceReadiness()


