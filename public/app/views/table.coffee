###
 * table
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:41
###

define [
  'text!templates/table.handlebars'
], (template)->
  Em.TEMPLATES.table = Em.Handlebars.compile template
  App.TableView = Em.View.extend
    tagName: 'table'
    templateName: 'table'
    classNames: ['table']
