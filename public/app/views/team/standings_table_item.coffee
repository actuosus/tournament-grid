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
], (template)->
  Em.TEMPLATES.teamStandingsTableItem = Em.Handlebars.compile template
  App.TeamStandingsTableItemView = Em.View.extend
    tagName: 'tr'
    templateName: 'teamStandingsTableItem'
    classNames: ['team-standings-table-item']
    classNameBindings: ['content.isSelected']

    mouseEnter: (event)->
      @matchesPopup = App.MatchTablePopupView.create
        target: @
        origin: 'top'
        entrant: @get('content.entrant')
        controller: @get('content.controller')
      @matchesPopup.append()

    mouseLeave: ->
      @matchesPopup.hide()

    click: -> @toggleProperty 'content.isSelected'