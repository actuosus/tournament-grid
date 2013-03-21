###
 * map_control
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 15:08
###

define ->
  App.MapControl = Ember.Mixin.create
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

      scale = @get('scale')
      scale = scale + event.originalEvent.wheelDeltaY/1000

      transformOrigin = "#{event.pageX - offset.left}px #{event.pageY - offset.top}px"
      @doScale scale, transformOrigin

    doScale: (scale, transformOrigin)->
      minScale = @get 'minScale'
      maxScale = @get 'maxScale'
      if minScale < scale < maxScale
        css = scale: scale
        css['transformOrigin'] = transformOrigin if transformOrigin
        @get('contentView').$().css css
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
      @doMove newPosition

    mouseUp: (event)->
      @oldPosition = @lastPosition
      $(document.body).unbind('mousemove.grid')
      $(document.body).unbind('mouseup.grid')
      $(document.body).removeClass('non-selectable')

    doMove: (newPosition)->
      scale = @get('scale')
      @get('contentView').$().css
        x: newPosition.x / scale
        y: newPosition.y / scale
        scale: scale
      @set 'lastPosition', newPosition

#    doubleClick: (event)->
#      if event.shiftKey
#        @doScale 1
#        return
#      offset = @$().offset()
#
#      scale = @get('scale')
#      scale = scale * 2
#
#      transformOrigin = "#{event.pageX - offset.left}px #{event.pageY - offset.top}px"
#      @doScale scale, transformOrigin
