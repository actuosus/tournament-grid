###
 * cell
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:28
###

define [
  'ember'
], ()->
  App.TableCellView = Ember.View.extend
    tagName: 'td'
    classNames: ['table-cell']
    defaultTemplate: Ember.Handlebars.compile(
      '<div class="content">{{view.cellContent}}</div>')
    row:        Ember.computed.alias 'parentView.row'
    rowContent: Ember.computed.alias 'row.content'
    column:         Ember.computed.alias 'content'

    cellContent: Ember.computed (key, value) ->
      row     = @get 'rowContent'
      column  = @get 'column'
      return unless row and column
      if arguments.length is 1
        value = column.getCellContent row
      else
        column.setCellContent row, value
      value
    .property 'row.isLoaded', 'column'