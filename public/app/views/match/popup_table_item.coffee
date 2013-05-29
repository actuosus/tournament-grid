###
 * popup_table_item
 * @author: actuosus
 * Date: 29/05/2013
 * Time: 18:37
###

define [
  'text!../../templates/match/popup_table_item.hbs'
], (template)->
  Em.TEMPLATES.matchesPopupTableItem = Em.Handlebars.compile template

  App.MatchPopupTableItemView = Em.View.extend
    tagName: 'tr'
    classNames: ['matches-table-item', 'popup-table-item']
    templateName: 'matchesPopupTableItem'