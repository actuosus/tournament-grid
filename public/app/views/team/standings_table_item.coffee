###
 * team_standings_table_item
 * @author: actuosus
 * @fileOverview
 * Date: 29/01/2013
 * Time: 17:59
###


define [
  'text!../../templates/team/standings_table_item.handlebars'
  'cs!../../core'
  'cs!./cell'
  'cs!./standing_cell'
], (template)->
  Em.TEMPLATES.teamStandingsTableItem = Em.Handlebars.compile template
  App.TeamStandingsTableItemView = Em.View.extend
    tagName: 'tr'
    templateName: 'teamStandingsTableItem'
    classNames: ['team-standings-table-item']
    classNameBindings: ['content.isSelected', 'content.isDirty', 'content.isSaving']

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
      if App.get('idEditingMode')
        unless $(event.target).hasClass 'editable-label'
          @toggleProperty 'content.isSelected'