###
 * team_info_item
 * @author: actuosus
 * @fileOverview 
 * Date: 29/01/2013
 * Time: 22:04
###

define [
  'text!templates/team_info_item.handlebars'
], (template)->
  Em.TEMPLATES.teamInfoItem = Em.Handlebars.compile template
  App.TeamInfoItemView = Em.View.extend
    tagName: 'li'
    templateName: 'teamInfoItem'
    classNames: ['team-info-item']
