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
         'screenfull'
], ->
  App.TournamentGridView = Em.ContainerView.extend App.MapControl,
    classNames: ['tournament-grid-container']
    childViews: ['contentView', 'bracketsView', 'fullScreenButtonView']

    didInsertElement: ->
      @_super()
      screenfull.onchange = @fullScreenChange.bind @

    fullScreenChange: ->
      console.log 'fullScreenChange'
      unless screenfull.isFullscreen
        @$().width @get('lastDimensions.width')
        @$().height @get('lastDimensions.height')

    isFullScreen: (->
      screenfull.isFullscreen
    ).property().volatile()

    bracketsView: Em.CollectionView.extend
      classNames: ['tournament-bracket-container']
      contentBinding: 'parentView.content.brackets'

      itemViewClass: Em.ContainerView.extend
        childViews: ['titleView', 'contentView']

        titleView: Em.View.extend
          classNames: ['tournament-bracket-name']
          contentBinding: 'parentView.content'
          template: Em.Handlebars.compile '{{view.content.name}}'

        contentView: Em.CollectionView.extend
          classNames: ['tournament-bracket']
          contentBinding: 'parentView.content.rounds'
          didInsertElement: ->
            @_super()
            console.log @get 'content'
            @$().width @get('content.length') * 181
          contentChanged: (->
            if @$()
              @$().width @get('content.length') * 181
          ).observes('content.length')

          itemViewClass: App.RoundGridItemView

    lastDimensions:
      width: 0
      height: 0

    fullScreenButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'fullscreen-btn']
      isFullScreenBinding: 'parentView.isFullScreen'
      classNameBindings: ['isFullScreen:exit']
      attributeBindings: ['title']
      title: (->
        if @get 'isFullScreen'
          '_exit_fullscreen'.loc()
        else
          '_enter_fullscreen'.loc()
      ).property('isFullScreen')
      template: Em.Handlebars.compile 'Fullscreen'
      click: (event)->
        if screenfull.enabled
          @set 'parentView.lastDimensions', {
            width: @get('parentView').$().width()
            height: @get('parentView').$().height()
          }
          @get('parentView').$().css
            width: window.screen.availWidth
            height: window.screen.availHeight

          console.log 'should fullscreen'
          screenfull.request @get 'parentView.element'


    contentView: Em.CollectionView.extend
      contentBinding: 'parentView.content._rounds'
      classNames: ['tournament-grid']

      didInsertElement: ->
        @_super()
        @$().width @get('content.length') * 181

      contentChanged: (->
        @$().width @get('content.length') * 181
      ).observes('content.length')

      mouseEnter: (event)->
        event.stopPropagation()

      itemViewClass: App.RoundGridItemView