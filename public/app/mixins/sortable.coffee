###
 * sortable
 * @author: actuosus
 * Date: 09/01/2014
 * Time: 11:10
###

define ->
  App.Sortable = Em.Mixin.create
    isSortable: yes
    isSorting: no

    sortProperty: 'sortIndex'

    axis: 'both'

    prev: null
    next: null

    mouseDown: (event)->
      nextView = @get('next')
      prevView = @get('prev')
      @set 'isMoving', yes
      $(document.body).addClass('non-selectable')
      $(document.body).bind('mousemove.sortable', @documentMouseMove.bind(@))
      $(document.body).bind('mouseup.sortable', @mouseUp.bind(@))
      position = @$().position()
      @$().css 'z-index', @get 'contentIndex'
      @startPosition =
        x: position.left
        y: position.top
      @startMousePosition =
        x: event.pageX
        y: event.pageY

    shouldSort: ()->
      if @get 'isSortable'
        nextView = @get('next')
        prevView = @get('prev')
        width = @$().width()
        if nextView and (@$().position().left + width > nextView.$().position().left + nextView.$().width()/2)
          return true
        else if prevView and (@$().position().left < prevView.$().position().left + prevView.$().width()/2)
          return true
        else
          return false

    doSort: ()->
      nextView = @get('next')
      prevView = @get('prev')
      width = @$().width()
      content = @get 'content'
      sortProperty = @get('sortProperty')
      if nextView and (@$().position().left + width > nextView.$().position().left + nextView.$().width()/2)
        nextContent = nextView.get 'content'
#        console.log nextView.$(), @startPosition
        @isSorting = yes
        nextView.$().transition({x: -width}, ()=>
          @$().before(nextView.$())
          @$().css({x: 0, y: 0})
          @mouseUp()
          @set 'contentIndex', @get('contentIndex')+1
          nextView.set 'contentIndex', @get('contentIndex')-1

          content.set sortProperty, content.get(sortProperty)+1
          nextContent.set sortProperty, nextContent.get(sortProperty)-1
          @isSorting = no
          content.save()
          nextContent.save()
        )
      else if prevView and (@$().position().left < prevView.$().position().left + prevView.$().width()/2)
        prevContent = prevView.get 'content'
        @isSorting = yes
        prevView.$().transition({x: width}, ()=>
          @$().after(prevView.$()).css({x: 0, y: 0})
          @mouseUp()
          @set 'contentIndex', @get('contentIndex')-1
          prevView.set 'contentIndex', @get('contentIndex')+1

          content.set sortProperty, content.get(sortProperty)-1
          prevContent.set sortProperty, prevContent.get(sortProperty)+1
          @isSorting = no
          content.save()
          prevContent.save()
        )

    documentMouseMove: (event)->
      newPosition =
        x: event.pageX - @startMousePosition.x
        y: event.pageY - @startMousePosition.y
      if @get 'isSortable'
        @doMove newPosition unless @isSorting

    doMove: (newPosition)->
      axis = @get 'axis'
      switch axis
        when 'x'
          style = x: newPosition.x
        when 'y'
          style = y: newPosition.y
        else
          style =
            x: newPosition.x
            y: newPosition.y

      @$().css style
      @set 'lastPosition', newPosition
      @doSort() if @shouldSort()

    mouseUp: ->
      @$().transition({x: 0, y: 0})
      @set 'isMoving', no
      $(document.body).unbind 'mousemove.sortable'
      $(document.body).unbind 'mouseup.sortable'
      $(document.body).removeClass 'non-selectable'