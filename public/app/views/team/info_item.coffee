###
 * team_info_item
 * @author: actuosus
 * Date: 29/01/2013
 * Time: 22:04
###

define [
  'ehbs!team/info_item'
  'cs!../../core'
], (template)->
#  Em.TEMPLATES.teamInfoItem = Em.Handlebars.compile template
  App.TeamInfoItemView = Em.View.extend
    tagName: 'li'
    templateName: 'team/info_item'
    classNames: ['team-info-item']
