###
 * application
 * @author: actuosus
 * @fileOverview Application initialization.
 * Date: 21/01/2013
 * Time: 07:31
###

define [
  'cs!./core'
  'cs!./system'
  'cs!./mixins'

  'cs!./controllers'
  'cs!./views'
  'cs!./models'
#  'cs!./fixtures'

  'cs!./router'

  'cs!./mixins/translatable'
  'cs!./mixins/collapsable'
  'cs!./translators/yandex'

#  'cs!./tree_test'
#  'cs!lib/node'

], ()->

#  App.set 'isEditingMode', yes

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
          when 192 # Paragraph
            popup = App.PopupView.create(showCloseButton: yes)
            popup.pushObject App.ServerDebugView.create()
            popup.append()

  App.RoundProxy = Em.ObjectProxy.extend
    isSelected: no
    content: null

  App.MatchProxy = Em.ObjectProxy.extend
    isSelected: no
    entrant1: (->
      console.log arguments
    ).property()
    entrant2: (->
      console.log arguments
    ).property()

    entrantsChanged: ((self, property)->
#        console.log arguments
      content = @get('content')
      unless content
        content = App.Match.createRecord()
        content.set property, @get property
        content.set 'sort_index', @get 'sort_index'
        content.set 'round', @get 'round.content'
        @set 'content', content
    ).observes('entrant1', 'entrant2')

    open: ->
      content = @get('content')
      content.open() if content

    close: ->
      content = @get('content')
      content.close() if content

    content: (->
#        match = @get('round.content.matches')?.objectAtContent @get 'sort_index'
#        @set('entrants', match.get('entrants')) if match
    ).property('some', 'round.content.matches.@each.isLoaded')

    some: null

    roundContentIsLoaded: (->
      @set 'some', @get 'round.index'
    ).observes('round.content.isLoaded')


  App.ready = ->
    $('#content').empty()

#    Em.run ->
    App.set 'report', App.Report.find window.currentReportId
#
    App.set 'entrantsController', App.EntrantsController.create()
    App.set 'countriesController', App.CountriesController.create()
    App.set 'teamsController', App.TeamsController.create()
#    App.set 'reportTeamsController', App.ReportEntrantsController.create contentBinding: 'App.report.teamRefs'
    App.set 'playersController', App.PlayersController.create()

#    TODO Socket support
#    App.socketController = App.SocketController.create()
#    App.socketController.connect()

    stageTabsView = App.StageTabsView.create()
    window.stageView = stageTabsView

    # Preloading countries
    App.countries = App.Country.find()

    stageSelectorContainerView = App.NamedContainerView.create
      title: '_tournament_results_table'.loc()
      contentView: stageTabsView

    App.get('report').didLoad = ->
      report = App.get 'report'
      stageTabsView.set 'content', report.get('stages')
#      App.racesController.set 'content', report.get('races')

      App.set 'reportTeamsController', App.ReportEntrantsController.create contentBinding: 'App.report.teamRefs'

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

      App.store.adapter.ajax = (url, type, hash)->
        hash.url = url
        hash.type = type
        hash.dataType = 'json'
        hash.contentType = 'application/json; charset=utf-8'
        hash.context = @

        if hash.data
          if type isnt 'GET'
            hash.url += "?report_id=#{report.get 'id'}"
            if App.debug?.wait?
              hash.url += '&' + jQuery.param({start: App.get('debug.wait.start'), end: App.get('debug.wait.end')})
            hash.data = JSON.stringify hash.data
          else
            hash.data.report_id = report.get 'id'
        else
          hash.url += "?report_id=#{report.get 'id'}"
          if App.debug?.wait?
            hash.url += '&' + jQuery.param({start: App.get('debug.wait.start'), end: App.get('debug.wait.end')})

        jQuery.ajax hash


    stageSelectorContainerView.appendTo '#content'

    App.peroids = Em.ArrayController.create
      content: [
        Em.Object.create name:'Все', id: 'all'

        Em.Object.create name:'Период', id: 'period'
        Em.Object.create name:'Дата', id: 'date'
        Em.Object.create name:'Сегодня', id: 'today'
        Em.Object.create name:'Завтра', id: 'tomorrow'
        Em.Object.create name:'Вчера', id: 'yesterday'
        Em.Object.create name:'Неделя', id: 'week'
        Em.Object.create name:'Месяц', id: 'month'
        Em.Object.create name:'Год', id: 'year'
      ]

    App.matchTypes = Em.ArrayController.create
      content: [
        Em.Object.create name:'Все', id: 'all'

        Em.Object.create name:'_future_match_type'.loc(), id: 'future'
        Em.Object.create name:'_active_match_type'.loc(), id: 'active'
        Em.Object.create name:'_delayed_match_type'.loc(), id: 'delayed'
        Em.Object.create name:'_past_match_type'.loc(), id: 'past'
      ]

    App.visualTypes = Em.ArrayController.create
      content: [
        Em.Object.create name:'_single'.loc(), id: 'single'
        Em.Object.create name:'_double'.loc(), id: 'double'
        Em.Object.create name:'_group'.loc(), id: 'group'
        Em.Object.create name:'_matrix'.loc(), id: 'matrix'
        Em.Object.create name:'_team'.loc(), id: 'team'
      ]

#    App.racesController = Em.ArrayController.create
#      content: [
#        Em.Object.create name: '_zerg'.loc(), id: 'zerg'
#        Em.Object.create name: '_protoss'.loc(), id: 'protos'
#        Em.Object.create name: '_terrain'.loc(), id: 'terrain'
#      ]
#      all: ->
#        @set 'content.isLoaded', yes
#      search: (options)->
#        result = @get('content').filter (item, idx)->
#          regexp = new RegExp(options.name, 'i')
#          if item.get('name')?.match regexp
#            return yes
#          if item.get('__name')?.match regexp
#            return yes
#          if item.get('englishName')?.match regexp
#            return yes
#        @set 'content.isLoaded', yes
#      menuItemViewClass: Em.View.extend
#        classNames: ['menu-item']
#        classNameBindings: ['isSelected']
#        template: Em.Handlebars.compile '{{view.content.name}}'
#        mouseDown: (event)->
#          event.stopPropagation()
#
#        click: (event)->
#          event.preventDefault()
#          event.stopPropagation()
#          @get('parentView').click(event)
#          @set 'parentView.selection', @get 'content'
#          @set 'parentView.value', @get 'content'
#          @set 'parentView.isVisible', no


    console.profileEnd('Loading');