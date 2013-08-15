###
 * movable
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 07:24
###

define ->
  App.Movable = Em.Mixin.create
    isMovable: yes
    isMoving: no

    axis: 'both'

    mouseDown: (event)->
      @set 'isMoving', yes
      $(document.body).addClass('non-selectable')
      $(document.body).bind('mousemove.movable', @documentMouseMove.bind(@))
      $(document.body).bind('mouseup.movable', @mouseUp.bind(@))
      @startMousePosition =
        x: event.pageX
        y: event.pageY

    documentMouseMove: (event)->
      newPosition =
        x: event.pageX - @startMousePosition.x
        y: event.pageY - @startMousePosition.y
      @doMove newPosition

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

    mouseUp: ->
      @set 'isMoving', no
      $(document.body).unbind 'mousemove.movable'
      $(document.body).unbind 'mouseup.movable'
      $(document.body).removeClass 'non-selectable'