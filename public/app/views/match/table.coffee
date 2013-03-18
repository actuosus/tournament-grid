###
 * matches_table
 * @author: actuosus
 * @fileOverview
 * Date: 28/01/2013
 * Time: 22:24
###

define [
  'text!templates/match/table.handlebars'
], (template)->
  Em.TEMPLATES.matchesTable = Em.Handlebars.compile template
  App.MatchesTableView = Em.View.extend
    tagName: 'table'
    templateName: 'matchesTable'
    classNames: ['matches-table', 'table']
