###
 * table
 * @author: actuosus
 * Date: 21/01/2013
 * Time: 07:41
###

define [
  'text!templates/table.handlebars'
], (template)->
  Em.TEMPLATES.table = Em.Handlebars.compile template
  App.TableView = Em.View.extend
    MIN_COLUMN_WIDTH: 30

    tagName: 'table'
    templateName: 'table'
    classNames: ['table']

    # References to DOM elements
    scrollable: null, # the scrollable div that holds the data table
    rowHeader: null, # the row header table element
    columnHeader: null, # the column header table element
    tableCorner: null,
