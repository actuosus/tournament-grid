###
 * popup_table_item
 * @author: actuosus
 * Date: 29/05/2013
 * Time: 18:37
###

define [
  'ehbs!match/popup_table_item'
], (template)->
#  Em.TEMPLATES.matchesPopupTableItem = Em.Handlebars.compile template

  App.MatchPopupTableItemView = Em.View.extend
    tagName: 'tr'
    classNames: ['matches-table-item', 'popup-table-item']
    templateName: 'match/popup_table_item'