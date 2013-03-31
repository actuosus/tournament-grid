###
 * tournament_grid
 * @author: actuosus
 * @fileOverview Basic tournament grid.
 * Date: 15/02/2013
 * Time: 20:33
###

define [
         'cs!../mixins/zooming'
         'cs!../mixins/map_control'
         'cs!./round/tournament_grid_item'
], ->
  App.TournamentGridView = Em.ContainerView.extend App.MapControl,
    classNames: ['tournament-grid-container']
    childViews: ['contentView', 'bracketsView']

    bracketsView: Em.CollectionView.extend
      classNames: ['tournament-bracket-container']
      contentBinding: 'parentView.content.brackets'

      itemViewClass: Em.CollectionView.extend
        classNames: ['tournament-bracket']
        contentBinding: 'content.rounds'
        didInsertElement: ->
          console.log @get 'content'
          @$().width @get('content.length') * 181
        contentChanged: (->
          if @$()
            @$().width @get('content.length') * 181
        ).observes('content.length')

        itemViewClass: App.RoundGridItemView

    contentView: Em.CollectionView.extend
      contentBinding: 'parentView.content.rounds'
      classNames: ['tournament-grid']

      didInsertElement: ->
        @$().width @get('content.length') * 181

      contentChanged: (->
        @$().width @get('content.length') * 181
      ).observes('content.length')

      mouseEnter: (event)->
        event.stopPropagation()

      itemViewClass: App.RoundGridItemView