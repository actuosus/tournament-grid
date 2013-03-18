###
 * lineup
 * @author: actuosus
 * @fileOverview
 * Date: 05/03/2013
 * Time: 13:19
###

define [
  'cs!views/grid'
  'text!templates/team/grid_item.handlebars'
], (grid, template)->
  Em.TEMPLATES.newTeamGridItem = Em.Handlebars.compile template
  App.LineupView = App.GridView.extend
    itemViewClass: Em.View.extend
      tagName: 'table'
      classNames: ['table', 'lineup-grid-item']
      templateName: 'newTeamGridItem'

      click: (event)->
        if $(event.target).hasClass('remove-btn')
          @get('content').deleteRecord()
          App.store.commit()