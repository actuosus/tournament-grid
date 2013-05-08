###
 * modal
 * @author: actuosus
 * Date: 06/05/2013
 * Time: 16:21
###

define [
  'cs!../core'
], ->
  App.ModalView = Em.ContainerView.extend
    classNames: ['modal']

    origin: 'center'

    getContentDimensions: ->
      contentView = @get('contentView')
      dimensions =
        width: contentView.$().width()
        height: contentView.$().height()
      dimensions

    didInsertElement: ->
      @_super()
      target = @get 'target'
      element = @get('element')
      origin = @get 'origin'
      dimensions = width: element.offsetWidth, height: element.offsetHeight
      if target
        offset = target.$().offset()
        targetWidth = target.$().width()
        targetHeight = target.$().height()
        if origin is 'center'
          offset.left += targetWidth/2 - dimensions.width/2
          offset.top += targetHeight/2 - dimensions.height/2
        @$().css({scale: 0})
        @$().css(offset)
        @show()
        $(document.body).bind('mousedown.popup', @onDocumentMouseDown.bind(@))

    mouseDown: (event)->
      event.stopPropagation()

    onDocumentMouseDown: (event)->
      $(document.body).unbind('mousedown.popup')
      @hide()

    show: (args)->
      @$().transition({ scale: 1 }, 300, (=> @trigger('show', args))) if @$()

    hide: (args)->
      @$().transition({ scale: 0 }, 300, (=> @trigger('hide', args); @destroy())) if @$()