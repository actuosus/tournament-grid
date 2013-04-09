###
 * matches_table
 * @author: actuosus
 * @fileOverview
 * Date: 28/01/2013
 * Time: 22:24
###

define [
  'text!../../templates/match/table_item.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.matchesTableItem = Em.Handlebars.compile template
  App.MatchesTableView = Em.CollectionView.extend
    tagName: 'table'
    classNames: ['matches-table', 'table']
    itemViewClass: Em.View.extend
      tagName: 'tr'
      classNames: ['matches-table-item']
      classNameBindings: ['content.isDirty']
      templateName: 'matchesTableItem'

      click: (event)->
        if $(event.target).hasClass('remove-btn')
          match = @get 'content'
          match.deleteRecord() if match
