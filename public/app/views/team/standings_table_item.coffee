###
 * team_standings_table_item
 * @author: actuosus
 * @fileOverview
 * Date: 29/01/2013
 * Time: 17:59
###


define [
  'text!../../templates/team/standings_table_item.hbs'
  'cs!../../core'
  'cs!./cell'
  'cs!./standing_cell'
], (template)->
  Em.TEMPLATES.teamStandingsTableItem = Em.Handlebars.compile template
  App.TeamStandingsTableItemView = Em.View.extend App.ContextMenuSupport,
    tagName: 'tr'
    templateName: 'teamStandingsTableItem'
    classNames: ['team-standings-table-item']
    classNameBindings: ['content.isSelected', 'content.isDirty', 'content.isSaving']
    
    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['save', 'deleteRecord:delete']
    
    save: ->
      @get('content.store')?.commit()
      
    delete: ->
      @get('content').deleteRecord()

    mouseEnter: (event)->
      controller = @get('parentView.matches')
      entrant = @get('content.entrant')
      if controller?.hasPastOrFutureMatchesForEntrant entrant
        @matchesPopup = App.MatchTablePopupView.create
          target: @
          origin: 'top'
          entrant: entrant
          controller: controller
        @matchesPopup.append()

    mouseLeave: -> @matchesPopup?.hide()

    click: (event)->
      if App.get('isEditingMode')
        unless $(event.target).hasClass 'editable-label'
          @toggleProperty 'content.isSelected'