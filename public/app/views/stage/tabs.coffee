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
  'cs!./form'
],->
  App.StageTabsView = Em.ContainerView.extend
    classNames: ['stage-view']
    childViews: ['tabBarView', 'contentView']

    content: null

    currentStageDidLoad: ->
      @setViewForStage @currentStage

    setViewForStage: (stage)->
      switch @currentStage.get 'visual_type'
        when 'grid'
          contentView = App.TournamentGridView.create content: @currentStage
        when 'group'
          contentView = App.GroupGridView.create
            content: @currentStage.get 'rounds'
            entrants: @currentStage.get 'entrants'
        when 'matrix'
#          console.log @currentStage.get('matches'), @currentStage.get('matches.length')
          contentView = App.GridView.create
            classNames: ['match-grid']
            itemViewClass: App.MatchGridItemView
            stage: @currentStage
#            content: @currentStage.get('matches')
            contentBinding: 'stage.matches'
        when 'team'
          teamsController = Em.ArrayController.create
            content: @currentStage.get('entrants')
            sortProperties: ['gamesPlayed']
          contentView = App.StangingTableView.create
            entrants: teamsController
            matches: @currentStage.get('rounds.firstObject.matches')
      @set 'currentView', contentView


    setCurrentTabView: (@currentTabView)->
      @currentStage = @currentTabView.get 'content'
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

        titleBinding: 'content.description'

        nameView: Em.View.extend
          contentBinding: 'parentView.content'
          template: Em.Handlebars.compile '{{name}}'

        removeButtonView: Em.View.extend
          tagName: 'button'
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          classNames: ['btn-clean', 'remove-btn', 'remove']
          attributeBindings: ['title']
          title: '_remove'.loc()
          template: Em.Handlebars.compile '×'

          click: -> @get('content').deleteRecord()
#          valueBinding: 'content.name'
        click: ->
          @get('parentView').selectChildView(@)
      contentBinding: 'parentView.content'
    contentView: Em.View.extend()