###
 * group_table
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 17:50
###

define [
  'text!../../templates/match/group_table.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.matchesGroupTable = Em.Handlebars.compile template
  App.MatchesGroupTableView = Em.View.extend
    tagName: 'table'
    templateName: 'matchesGroupTable'
    classNames: ['matches-group-table', 'table']