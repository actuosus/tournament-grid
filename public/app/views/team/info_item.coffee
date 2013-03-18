###
 * team_info_item
 * @author: actuosus
 * Date: 29/01/2013
 * Time: 22:04
###

define [
  'text!templates/team/info_item.handlebars'
], (template)->
  Em.TEMPLATES.teamInfoItem = Em.Handlebars.compile template
  App.TeamInfoItemView = Em.View.extend
    tagName: 'li'
    templateName: 'teamInfoItem'
    classNames: ['team-info-item']
