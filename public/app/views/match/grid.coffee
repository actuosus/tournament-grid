###
 * match_grid
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 04:56
###

define [
  'ehbs!grid.handlebars'
  'cs!../../core'
], (template)->
#  Em.TEMPLATES.grid = Em.Handlebars.compile template
  App.MatchGridView = Em.View.extend
    templateName: 'grid'
    classNames: ['match-grid']