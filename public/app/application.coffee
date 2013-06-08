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
], ()->

  $(document.body).keydown (event)->
    if event.ctrlKey
      if event.shiftKey
        switch event.keyCode
          when 65 # a
            App.toggleConfig()
          when 69 # e
            notification = App.notificationsController.createNotification
              icon: null
              title: 'Editing mode'
              content: 'Editing mode changed.'
            notification?.show()
            App.set 'isEditingMode', not App.get('isEditingMode')
          when 90 # z
            History.undo()
          when 192 # Paragraph
            popup = App.PopupView.create(showCloseButton: yes)
            popup.pushObject App.ServerDebugView.create()
            popup.append()

  App.ready = ->
#    App.set 'entrantsController', App.EntrantsController.create()
#    App.set 'countriesController', App.CountriesController.create()
#    App.set 'teamsController', App.TeamsController.create()
#    App.set 'playersController', App.PlayersController.create()

    App.NotificationsController = Em.ArrayController.extend
      requestPermission: ->
        window.webkitNotifications.requestPermission()
      createNotification: (options)->
        if window.webkitNotifications.checkPermission() is 0
          window.webkitNotifications.createNotification(options.icon, options.title, options.content)
        else
          @requestPermission()


    App.set 'notificationsController', App.NotificationsController.create()
#
##    TODO Socket support
##    App.socketController = App.SocketController.create()
##    App.socketController.connect()
#
#    # Preloading countries
#    App.countries = App.Country.find()
#
#    App.get('report').didLoad = ->
#      report = App.get 'report'
#      stageTabsView.set 'content', report.get('stages')
##      App.racesController.set 'content', report.get('races')
#
#      App.set 'reportTeamsController', App.ReportEntrantsController.create contentBinding: 'App.report.teamRefs'
#
#      if report?.get('match_type') is 'team'
#        reportEntrants = App.ReportEntrantsController.create
#          contentBinding: 'App.report.teamRefs'
##        reportEntrants = App.EntrantsController.create
##          sortProperties: ['team.name']
##          contentBinding: 'App.report.teamRefs'
#        lineupView = App.LineupView.create
#          classNames: ['team-lineup-grid']
#          controller: reportEntrants
#          contentBinding: 'controller.arrangedContent'
##          contentBinding: 'App.report.teamRefs'
#
#        window.lineupView = lineupView
#        lineupContainerView = App.LineupContainerView.create contentView: lineupView
#        lineupContainerView.appendTo '#content'
#
#        unless window.stageView.get('currentStage')
#          window.stageView.get('controller')?.transitionToRoute 'stage', App.get('report.stages.firstObject')
#
#
#    stageSelectorContainerView.appendTo '#content'
#
#    App.peroids = Em.ArrayController.create
#      content: [
#        Em.Object.create name:'Все', id: 'all'
#
#        Em.Object.create name:'Период', id: 'period'
#        Em.Object.create name:'Дата', id: 'date'
#        Em.Object.create name:'Сегодня', id: 'today'
#        Em.Object.create name:'Завтра', id: 'tomorrow'
#        Em.Object.create name:'Вчера', id: 'yesterday'
#        Em.Object.create name:'Неделя', id: 'week'
#        Em.Object.create name:'Месяц', id: 'month'
#        Em.Object.create name:'Год', id: 'year'
#      ]
#
#    App.matchTypes = Em.ArrayController.create
#      content: [
#        Em.Object.create name:'Все', id: 'all'
#
#        Em.Object.create name:'_future_match_type'.loc(), id: 'future'
#        Em.Object.create name:'_active_match_type'.loc(), id: 'active'
#        Em.Object.create name:'_delayed_match_type'.loc(), id: 'delayed'
#        Em.Object.create name:'_past_match_type'.loc(), id: 'past'
#      ]
#
#    App.visualTypes = Em.ArrayController.create
#      content: [
#        Em.Object.create name:'_single'.loc(), id: 'single'
#        Em.Object.create name:'_double'.loc(), id: 'double'
#        Em.Object.create name:'_group'.loc(), id: 'group'
#        Em.Object.create name:'_matrix'.loc(), id: 'matrix'
#        Em.Object.create name:'_team'.loc(), id: 'team'
#      ]
#
##    App.racesController = Em.ArrayController.create
##      content: [
##        Em.Object.create name: '_zerg'.loc(), id: 'zerg'
##        Em.Object.create name: '_protoss'.loc(), id: 'protos'
##        Em.Object.create name: '_terrain'.loc(), id: 'terrain'
##      ]
##      all: ->
##        @set 'content.isLoaded', yes
##      search: (options)->
##        result = @get('content').filter (item, idx)->
##          regexp = new RegExp(options.name, 'i')
##          if item.get('name')?.match regexp
##            return yes
##          if item.get('__name')?.match regexp
##            return yes
##          if item.get('englishName')?.match regexp
##            return yes
##        @set 'content.isLoaded', yes
##      menuItemViewClass: Em.View.extend
##        classNames: ['menu-item']
##        classNameBindings: ['isSelected']
##        template: Em.Handlebars.compile '{{view.content.name}}'
##        mouseDown: (event)->
##          event.stopPropagation()
##
##        click: (event)->
##          event.preventDefault()
##          event.stopPropagation()
##          @get('parentView').click(event)
##          @set 'parentView.selection', @get 'content'
##          @set 'parentView.value', @get 'content'
##          @set 'parentView.isVisible', no


    console.profileEnd('Loading');