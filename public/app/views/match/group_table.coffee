###
 * group_table
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 17:50
###

define [
  'text!../../templates/match/group_table_item.handlebars'
  'cs!../../core'
  'cs!../number'
], (template)->
  Em.TEMPLATES.matchesGroupTableItem = Em.Handlebars.compile template
  App.MatchesGroupTableView = Em.CollectionView.extend
    tagName: 'table'
    classNames: ['matches-group-table', 'table']
    itemViewClass: Em.View.extend
      tagName: 'tr'
      classNames: ['matches-table-item']
      classNameBindings: ['content.isDirty']
      templateName: 'matchesGroupTableItem'
      click: (event)->
        if $(event.target).hasClass('remove-btn')
          match = @get 'content'
          match.deleteRecord() if match
