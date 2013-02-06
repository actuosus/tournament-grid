###
 * team_standings_table_item
 * @author: actuosus
 * @fileOverview 
 * Date: 29/01/2013
 * Time: 17:59
###


define [
  'text!templates/team_standings_table_item.handlebars'
], (template)->
  Em.TEMPLATES.teamStandingsTableItem = Em.Handlebars.compile template
  App.TeamStandingsTableItemView = Em.View.extend
    tagName: 'tr'
    templateName: 'teamStandingsTableItem'
    classNames: ['team-standings-table-item']

    didInsertElement: ->
      @teamTooltipView = @get 'childViews.firstObject'
      @matchesTooltipView = @get('childViews').objectAt(1)
      @.$('.team-name').tooltip(html: yes, title: @teamTooltipView.get('element'), trigger: 'click').tooltip('toggle').tooltip('toggle')
      @.$('.team-losses').tooltip(html: yes, title: @matchesTooltipView.get('element'), trigger: 'click').tooltip('toggle').tooltip('toggle')
#      @tooltipView.set 'isVisible', no
#
#    mouseEnter: (event)->
#      if $(event.target).hasClass('team-name')
#        @tooltipView.set 'isVisible', yes