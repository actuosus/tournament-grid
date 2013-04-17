###
 * templates
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 19:05
###

define [
  'text!./templates/body-container.hbs'
  'text!./templates/footer-container.hbs'
  'text!./templates/header-cell.hbs'
  'text!./templates/header-container.hbs'
  'text!./templates/header-row.hbs'
  'text!./templates/table-row.hbs'
  'text!./templates/tables-container.hbs'
], (body, footer, headerCell, headerContainer, headerRow, tableRow, tablesContainer)->
  Em.TEMPLATES['tables-container'] = Em.Handlebars.compile tablesContainer
  Em.TEMPLATES['table-row'] = Em.Handlebars.compile tableRow
  Em.TEMPLATES['header-row'] = Em.Handlebars.compile headerRow
  Em.TEMPLATES['header-cell'] = Em.Handlebars.compile headerCell
  Em.TEMPLATES['header-container'] = Em.Handlebars.compile headerContainer
  Em.TEMPLATES['body-container'] = Em.Handlebars.compile body
  Em.TEMPLATES['footer-container'] = Em.Handlebars.compile footer
