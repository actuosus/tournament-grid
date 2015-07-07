###
 * group_table_item
 * @author: actuosus
 * Date: 29/05/2013
 * Time: 13:35
###

define [
  'ehbs!match/group_table_item'
  'cs!./table_item'
], (template)->
#  Em.TEMPLATES.matchesGroupTableItem = Em.Handlebars.compile template
  App.MatchGroupTableItemView = App.MatchTableItemView.extend App.MatchDelegate,
    tagName: 'tr'
    classNames: ['matches-table-item']
    classNameBindings: ['content.isDirty']
    templateName: 'match/group_table_item'