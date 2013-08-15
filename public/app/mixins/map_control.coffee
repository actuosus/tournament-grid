###
 * map_control
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 15:08
###

define ['cs!../core'],->
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

    zoomIn: (animated)->
      scale = @get 'scale'
      scale = scale*1.2
      if animated
        @doScaleAnimated scale
      else
        @doScale scale

    zoomOut: (animated)->
      scale = @get 'scale'
      scale = scale/1.2
      if animated
        @doScaleAnimated scale
      else
        @doScale scale

    reset: (animated)->
      # TODO Kind of hacky.
      @set 'scale', 1
      @resetPosition animated

    resetZoom: (animated)->
      if animated
        @doScaleAnimated 1
      else
        @doScale 1

    resetPosition: (animated)->
      if animated
        @doMoveAnimated {x: 0, y: 0}
      else
        @doMove {x: 0, y: 0}

    mouseWheel: (event)->
      if event.shiftKey
        offset = @$().offset()

        scale = @get('scale')
        scale = scale + event.originalEvent.wheelDelta/1000

        if @canScale(scale)
          event.preventDefault()
          transformOrigin = "#{event.pageX - offset.left}px #{event.pageY - offset.top}px"
          @doScale scale, transformOrigin

    canScale: (newScale)->
      minScale = @get 'minScale'
      maxScale = @get 'maxScale'
      minScale < newScale < maxScale

    doScale: (scale, transformOrigin)->
      if @canScale(scale)
        css = scale: scale
        css['transformOrigin'] = transformOrigin if transformOrigin
        @get('contentView').$().css css
        @set('scale', scale)

    doScaleAnimated: (scale, transformOrigin)->
      if @canScale(scale)
        css = scale: scale
        css['transformOrigin'] = transformOrigin if transformOrigin
        @get('contentView').$().transition css
        @set('scale', scale)

    mouseDown: (event)->
      $(document.body).bind('mousemove.grid', @documentMouseMove.bind(@));
      $(document.body).bind('mouseup.grid', @mouseUp.bind(@));
      $(document.body).addClass('non-selectable')
      @startMousePosition =
        x: event.pageX
        y: event.pageY

    documentMouseMove: (event)->
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

    doMoveAnimated: (newPosition)->
      scale = @get('scale')
      @get('contentView').$().transition
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
