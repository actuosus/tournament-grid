###
 * movable
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 07:24
###

define ->
  App.Movable = Em.Mixin.create
    isMoving: no

    mouseDown: (event)->
      @set 'isMoving', yes
      $(document.body).addClass('non-selectable')
      $(document.body).bind('mousemove.movable', @onDocumentMouseMove.bind(@))
      $(document.body).bind('mouseup.movable', @mouseUp.bind(@))
      @startMousePosition =
        x: event.pageX
        y: event.pageY

    onDocumentMouseMove: (event)->
      newPosition =
        x: event.pageX - @startMousePosition.x
        y: event.pageY - @startMousePosition.y
      @doMove newPosition

    doMove: (newPosition)->
      @$().css
        x: newPosition.x
        y: newPosition.y
      @set 'lastPosition', newPosition

    mouseUp: ->
      @set 'isMoving', no
      $(document.body).unbind 'mousemove.movable'
      $(document.body).unbind 'mouseup.movable'
      $(document.body).removeClass 'non-selectable'