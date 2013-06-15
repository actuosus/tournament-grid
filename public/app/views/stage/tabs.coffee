###
 * tabs
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:57
###

define [
  'cs!../../core'
  'cs!../group_grid'
  'cs!../grid'
  'cs!../standing_table'
  'cs!../match/grid_container'
  'cs!../../controllers/matches'
  'cs!./form'
  'cs!../tab'
],->
  App.StageTabsView = App.TabView.extend
    classNames: ['stage-view']

    currentView: ((stage)->
      stage = @get 'selection.content'
      return Em.View.create() unless stage
      switch stage.get 'visualType'
        when 'single', 'grid'
          stage.get('matches')
          contentView = App.NewTournamentGridView.create
            stage: stage
            entrantsNumber: stage.get('entrantsNumber')
        when 'double'
          contentView = App.NewDoubleTournamentGridView.create
            stage: stage
            entrantsNumber: stage.get('entrantsNumber')
        when 'group'
          contentView = App.GroupGridView.create
            content: stage.get 'rounds'
            entrants: stage.get 'entrants'
            showFilterForm: no
            tableItemViewClass: 'App.MatchGroupTableItemView'
        when 'matrix'
          matchesController = App.MatchesController.create(stage: stage, contentBinding: 'stage.matches')
          contentView = App.MatchGridContainer.create
            stage: stage
            content: matchesController
        when 'team'
          teamsController = App.ReportEntrantsController.create
            searchPath: 'name'
            stage: stage
            contentBinding: 'stage.entrants'
          matchesController = App.MatchesController.create
            round: stage.get('rounds.firstObject')
            content: stage.get('rounds.firstObject.matches')
          contentView = App.StandingTableView.create
            classNames: ['for-team']
            entrants: teamsController
            matches: matchesController
            showFilterForm: yes
            tableItemViewClass: 'App.MatchTableItemView'
      contentView
    ).property('selection')

    tabBarView: Em.ContainerView.extend( App.ContextMenuSupport, {
      classNames: ['i-listsTabs', 'i-listsTabs_bd']
      contentBinding: 'parentView.controller'
      childViews: ['tabsView']

      selectionBinding: 'parentView.selection'

      tabsView: Em.CollectionView.extend
        tagName: 'ul'
        classNames: 'b-listsTabs'
        contentBinding: 'parentView.content'
        selectionBinding: 'parentView.selection'
        itemViewClass: Em.ContainerView.extend( App.ContextMenuSupport, App.Editing, {
          tagName: 'li'
          classNames: ['item', 'stage-tab-item']
          classNameBindings: ['active', 'isFocused', 'content.isDirty', 'content.isSaving', 'content.isUpdating', 'content.isError']
          childViews: ['titleView']
          attributeBindings: ['title']
          _isEditingBinding: 'App.isEditingMode'
          editingChildViews: ['removeButtonView']

          selectionBinding: 'parentView.selection'

          shouldShowContextMenuBinding: 'App.isEditingMode'
          contextMenuActions: ['edit', 'deleteRecord:delete']

          titleBinding: 'content.description'

          edit: ->
            @popup = App.PopupView.create target: @
            @popup.pushObject App.StageForm.create content: @get 'content'
            @popup.append()

          deleteRecord: -> @get('content').deleteRecord()

          currentWhen: 'stage'

          active: (->
            router = @get 'router'
            content = @get 'content'
            return unless router
            currentWithIndex = @currentWhen + '.index'
            router.isActive.apply(router, [@currentWhen].concat(content)) or
              router.isActive.apply(router, [currentWithIndex].concat(content))
          ).property('namedRoute', 'router.url')

          routeChanged: (->
            @set 'selection', @ if @get 'active'
          ).observes('router.url')

          router: (->
            @get('controller.container')?.lookup('router:main')
          ).property('controller')

          titleView: Em.View.extend
            template: Em.Handlebars.compile '{{view.parentView.content.title}}'

          removeButtonView: App.RemoveButtonView.extend
            title: '_remove_stage'.loc()
            deleteRecord: -> @get('parentView').deleteRecord()
            click: (event)->
              event.stopPropagation()

          click: ->
            @set 'selection', @

            router = @get 'router'
            router.transitionTo @currentWhen, @get 'content' if router
        })

      shouldShowContextMenuBinding: 'App.isEditingMode'
      contextMenuActions: ['add']

      add: -> @addItem()

      doubleClick: -> @addItem()

      addActive: (->
        router = @get 'router'
        return unless router
        router.isActive.apply(router, ['stages.new'])
      ).property('router.url')

      router: (->
        @get('controller.container')?.lookup('router:main')
      ).property('controller')

      addItem: ->
        router = @get 'router'
        router.transitionTo 'stages.new' if router
        stageForm = App.StageForm.create(classNames: ['padded'], report: App.report)
        stageForm.on 'cancel', =>
          window.history.back()
        @set 'parentView.currentView', stageForm

      click: (event)->
        if $(event.target).hasClass('add')
          @addItem()
    })