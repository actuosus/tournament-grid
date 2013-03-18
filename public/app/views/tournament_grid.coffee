###
 * tournament_grid
 * @author: actuosus
 * @fileOverview Basic tournament grid.
 * Date: 15/02/2013
 * Time: 20:33
###

define [
         'cs!views/team/grid_item'
         'cs!views/game/info_bar'
], ->
  App.TournamentGridView = Em.ContainerView.extend
    classNames: ['tournament-grid-container']
    childViews: ['contentView']

    scale: 1
    minScale: 0.15
    maxScale: 3.6

    startMousePosition:
      x: 0
      y: 0
    lastPosition:
      x: 0
      y: 0
    oldPosition:
      x: 0
      y: 0

    startScalePosition:
      x: 0
      y: 0

    scaleTimer: null

    mouseWheel: (event)->
      return if event.shiftKey
      event.preventDefault()

#      console.log (event)

      offset = @$().offset()

      minScale = @get 'minScale'
      maxScale = @get 'maxScale'
      scale = @get('scale')
      scale = scale + event.originalEvent.wheelDeltaY/1000
      if minScale < scale < maxScale
        transformOrigin = "#{event.pageX - offset.left}px #{event.pageY - offset.top}px"
        console.log transformOrigin
        @get('contentView').$().css(scale: scale, transformOrigin: transformOrigin)
        @set('scale', scale)

    mouseDown: (event)->
      $(document.body).bind('mousemove.grid', @onDocumentMouseMove.bind(@));
      $(document.body).bind('mouseup.grid', @mouseUp.bind(@));
      $(document.body).addClass('non-selectable')
      @startMousePosition =
        x: event.pageX
        y: event.pageY

    onDocumentMouseMove: (event)->
      $(document.body).addClass('non-selectable')
      newPosition =
        x: event.pageX - @startMousePosition.x + @oldPosition.x
        y: event.pageY - @startMousePosition.y + @oldPosition.y
      @move newPosition

    mouseUp: (event)->
      @oldPosition = @lastPosition
      $(document.body).unbind('mousemove.grid')
      $(document.body).unbind('mouseup.grid')
      $(document.body).removeClass('non-selectable')

    move: (newPosition)->
      scale = @get('scale')
      @get('contentView').$().css
        x: newPosition.x / scale
        y: newPosition.y / scale
        scale: scale
      @set 'lastPosition', newPosition

    contentView: Em.CollectionView.extend
      contentBinding: 'parentView.content.rounds'
      classNames: ['tournament-grid']

      didInsertElement: ->
        console.log @get('content')
        @$().width @get('content.length') * 181

      contentLoaded: (->
        console.log 'Loaded'
      ).observes('content.isLoaded')

      mouseEnter: (event)->
        event.stopPropagation()

      itemViewClass: Em.ContainerView.extend
        classNames: ['tournament-round-container']
        childViews: ['nameView', 'contentView']

        didInsertElement: ->
          @$().css float: 'left'

        nameView: App.EditableLabel.extend
          classNames: ['round-name']
          valueBinding: 'parentView.content.name'

        contentView: Em.CollectionView.extend
          classNames: ['tournament-round']
          roundBinding: 'content'
          contentBinding: 'parentView.content.matches'
          attributeBindings: ['contentIndex']

          itemViewClass: Em.ContainerView.extend
            classNames: ['tournament-match']
            childViews: ['dateView', 'infoBarView', 'connectorView', 'contentView']
            classNameBindings: ['content.isSelected']
            roundIndexBinding: 'parentView.parentView.contentIndex'

            mouseEnter: ->
              node = @get 'content'
              while node
                node.set('isSelected', yes)
                node = node.get('parentNode')

            mouseLeave: ->
              node = @get 'content'
              while node
                node.set('isSelected', no)
                node = node.get('parentNode')

            didInsertElement: ->
              console.log (@get 'content')
              height = 45
              @$().css(height: height * 2)
              if @get('parentView.parentView.contentIndex') is 0
                if @get('contentIndex') is 0
                  null
              else
                currentIndex = Math.pow(2, @get('roundIndex')) - 1
                if @get('contentIndex') is 0
                  @$().css marginTop: currentIndex * height
                else
                  @$().css marginTop: currentIndex * (height * 2)

            connectorView: Em.View.extend
              classNames: ['connector']
              template: Em.Handlebars.compile('<div class="one"></div><div class="another"></div>')
              contentIndexBinding: 'parentView.contentIndex'
              roundIndexBinding: 'parentView.roundIndex'
              didInsertElement: ->
                height = 45
                roundIndex = @get 'roundIndex'
                contentIndex = @get 'contentIndex'
                currentIndex = Math.pow(2, roundIndex)
                console.log contentIndex
                if contentIndex%2
                  top = -(currentIndex * height) + height
                  @$().addClass('diff')
                else
                  top = 39
                @$().css {top: top, left: 156, height: currentIndex * height - (19/2)}

            dateView: App.EditableLabel.extend
              classNames: ['match-start-date']
              contentBinding: 'parentView.content.date'
              valueChanged: (->
                console.log 'valueChanged'
              ).observes('value')
              value: (->
                console.log arguments
                moment(@get 'content.date').format('DD.MM.YY')
              ).property('content')
#              template: Em.Handlebars.compile('{{moment view.content.date format=DD.MM.YY}}')

            infoBarView: App.GamesInfoBarView.extend
              contentBinding: 'parentView.content.games'
              showInfoLabel: yes
              classNames: ['match-info-bar']

            contentView: Em.CollectionView.extend
              classNames: ['match-grid-item']
              matchBinding: 'parentView.content'
              contentBinding: 'parentView.content.entrants'

              itemViewClass: App.TeamGridItemView