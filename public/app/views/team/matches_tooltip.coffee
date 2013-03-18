###
 * team_matches_tooltip
 * @author: actuosus
 * Date: 01/02/2013
 * Time: 22:01
###

define [
  'text!templates/team/matches_tooltip.handlebars'
], (template)->
  Em.TEMPLATES.teamMatchesTooltip = Em.Handlebars.compile template
  App.TeamMatchesTooltipView = Em.View.extend
    templateName: 'teamMatchesTooltip'
    classNames: ['team-matches-tooltip']
