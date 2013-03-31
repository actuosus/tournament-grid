###
 * team_info_tooltip
 * @author: actuosus
 * @fileOverview
 * Date: 29/01/2013
 * Time: 18:06
###

define [
  'text!../../templates/team/info_tooltip.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.teamInfoTooltip = Em.Handlebars.compile template
  App.TeamInfoTooltipView = Em.View.extend
    templateName: 'teamInfoTooltip'
    classNames: ['team-info-tooltip']
