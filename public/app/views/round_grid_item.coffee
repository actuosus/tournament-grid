###
 * round_grid_item
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 14:30
###

define [
  'text!templates/round_grid_item.handlebars'
], (template)->
  Em.TEMPLATES.roundGridItem = Em.Handlebars.compile template
  App.RoundGridItemView = Em.View.extend
    templateName: 'roundGridItem'
    classNames: ['round-grid-item']
