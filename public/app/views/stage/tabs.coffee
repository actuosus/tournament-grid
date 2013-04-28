###
 * tabs
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:57
###

define [
  'cs!../../core'
  'cs!../tournament_grid'
  'cs!../group_grid'
  'cs!../grid'
  'cs!../standing_table'
  'cs!../match/grid_item'
  'cs!../../controllers/matches'
  'cs!./form'
],->
  App.StageTabsView = Em.ContainerView.extend
    classNames: ['stage-view']
    childViews: ['tabBarView', 'contentView']

    content: null
    currentStage: null

    currentStageDidLoad: ->
      @setViewForStage @currentStage

    setViewForStage: (stage)->
      switch @currentStage.get 'visual_type'
        when 'single', 'double', 'grid'
          @currentStage.get('matches')
          contentView = App.TournamentGridView.create content: @currentStage
        when 'group'
          contentView = App.GroupGridView.create
            content: @currentStage.get 'rounds'
            entrants: @currentStage.get 'entrants'
        when 'matrix'
#          console.log @currentStage.get('matches'), @currentStage.get('matches.length')
          matchesController = App.MatchesController.create(content: @currentStage.get('matches'))
          contentView = App.GridView.create
            classNames: ['match-grid']
            itemViewClass: App.MatchGridItemView
            stage: @currentStage
#            content: @currentStage.get('matches')
            content: matchesController
#            contentBinding: 'stage.matches'
        when 'team'
          teamsController = Em.ArrayController.create
            content: @currentStage.get('entrants')
#            sortProperties: ['gamesPlayed']
          matchesController = App.MatchesController.create
            content: @currentStage.get('rounds.firstObject.matches')
          contentView = App.StangingTableView.create
            entrants: teamsController
            matches: matchesController
      @set 'currentView', contentView

    setCurrentTabView: (@currentTabView)->
      @currentStage = @currentTabView.get 'content'

      @get('container').lookup('router:main').transitionTo('stages')

      console.log '@currentStage', @currentStage, @currentStage.get 'visual_type'
#      @currentStage.on 'didLoad', @currentStageDidLoad.bind(@)
      @currentStage.addObserver 'data', @, @currentStageDidLoad
      @setViewForStage @currentStage


    tabBarView: Em.View.extend
      classNames: ['i-listsTabs', 'i-listsTabs_bd']
      template: Em.Handlebars.compile '''
                                      <ul class="b-listsTabs">
                                      {{#each view.content}}
                                        {{view view.itemViewClass contentBinding=this}}
                                      {{/each}}
                                      {{#if App.isEditingMode}}
                                      <li class="item add"><button class="btn-clean add">+</button></li>
                                      {{/if}}

                                      </ul>
                                      '''

      didInsertElement: ->
        @_super()
        @selectChildView @get('childViews.firstObject.childViews.firstObject')

      click: (event)->
        if $(event.target).hasClass('add')
          @set 'parentView.currentView', App.StageForm.create(classNames: ['padded'], report: App.report)

      selectChildView: (childView)->
        @get('childViews').forEach (child)=>
          properChild = child.get('childViews').objectAt 0
          if Em.isEqual(properChild , childView)
            @get('parentView').setCurrentTabView properChild
            properChild.$().addClass('active')
          else
            properChild .$().removeClass('active')

#        itemViewClass: App.MultilingualEditableLabel.extend
      itemViewClass: Em.ContainerView.extend
        tagName: 'li'
        classNames: ['item']
        classNameBindings: ['isEditing', 'content.isUpdating']
        isEditingBinding: 'App.isEditingMode'
        childViews: ['nameView', 'removeButtonView']
        languages: App.languages
        attributeBindings: ['title']

#        active: (->
#          router = @get 'router'
#          params = resolvedPaths @parameters
#          currentWithIndex = @currentWhen + '.index'
#          isActive = router.isActive.apply(router, [this.currentWhen].concat(params)) or
#            router.isActive.apply(router, [currentWithIndex].concat(params))
#
#          @get 'activeClass' if isActive
#        ).property('namedRoute', 'router.url')

#        router: (->
#          @get('controller').container.lookup('router:main')
#        ).property()

        titleBinding: 'content.description'

        nameView: Em.View.extend
          contentBinding: 'parentView.content'
          template: Em.Handlebars.compile '{{__name}}'

        remove: -> @get('content').deleteRecord()

        removeButtonView: App.RemoveButtonView.extend
          title: '_remove_stage'.loc()
          remove: -> @get('parentView').remove()
          click: (event)->
            event.stopPropagation()
            @_super()

        click: ->
#          router = @get 'router'
#          router.transitionTo.apply(router, args(this, router))

          @get('parentView').selectChildView(@)
      contentBinding: 'parentView.content'
    contentView: Em.View.extend()