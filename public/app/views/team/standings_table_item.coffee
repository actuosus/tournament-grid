###
 * team_standings_table_item
 * @author: actuosus
 * @fileOverview
 * Date: 29/01/2013
 * Time: 17:59
###


define [
  'ehbs!team/standings_table_item'
  'cs!../../core'
  'cs!./cell'
  'cs!./standing_cell'
], (template)->
#  Em.TEMPLATES.teamStandingsTableItem = Em.Handlebars.compile template
  App.TeamStandingsTableItemView = Em.View.extend App.ContextMenuSupport,
    tagName: 'tr'
    templateName: 'team/standings_table_item'
    classNames: ['team-standings-table-item']
    classNameBindings: ['content.isSelected', 'content.isDirty', 'content.isSaving']
    
    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['save', 'deleteRecord:delete']
    
    save: ->
      console.log @get('content')
      @get('content')?.save().then =>
        @get('content.round')?.save()

    deleteRecord: ->
      content = @get('content')
      content?.deleteRecord()
      content?.save()

    shouldShowPopup: no

    playersPopupShown: (->
      if @get 'content.entrant.hasPlayersPopupShown'
        @set 'shouldShowPopup', no
        @matchesPopup?.hide()
    ).observes('content.entrant.hasPlayersPopupShown')

    mouseEnter: (event)->
      @set 'shouldShowPopup', yes
      controller = @get('parentView.matches')
      entrant = @get('content.entrant')
      if entrant?.get 'hasPlayersPopupShown'
        @set 'shouldShowPopup', no
      Em.run.later =>
        if @get('shouldShowPopup') and controller?.hasPastOrFutureMatchesForEntrant entrant
          @matchesPopup = App.MatchTablePopupView.create
            target: @
            origin: 'top'
            entrant: entrant
            controller: controller
          @matchesPopup.appendTo App.get 'rootElement'
          @set 'shouldShowPopup', no
      , 1000

    mouseLeave: ->
      @set 'shouldShowPopup', no
      @matchesPopup?.hide()

    click: (event)->
      if App.get('isEditingMode')
        if $(event.target).hasClass 'remove-btn'
          @deleteRecord()
          return
        unless $(event.target).hasClass 'editable-label'
          @toggleProperty 'content.isSelected'