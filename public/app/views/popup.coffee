###
 * popup
 * @author: actuosus
 * @fileOverview
 * Date: 03/03/2013
 * Time: 19:00
###

define ['cs!../core'],->
  App.PopupView = Em.ContainerView.extend
    classNames: ['popup']

    target: null

    childViews: ['arrowBorderView', 'arrowView']

    arrowView: Em.View.extend
      classNames: ['popup-arrow']

    arrowBorderView: Em.View.extend
      classNames: ['popup-arrow-border']

    getContentDimensions: ->
      contentView = @get('contentView')
      dimensions =
        width: contentView.$().width()
        height: contentView.$().height()
      dimensions

    didInsertElement: ->
      @_super()
      target = @get('target')
#      targetElement = target.get('element')
      element = @get('element')
      dimensions = width: element.offsetWidth, height: element.offsetHeight
#      targetDimensions = width: targetElement.offsetWidth, height: targetElement.offsetHeight
#      console.log dimensions
      if target
        offset = target.$().offset()
        targetWidth = target.$().width()
        targetHeight = target.$().height()
        offset.left += targetWidth
        offset.top += targetHeight/2 - 30

        transformOriginX = '-10px'

        if offset.left + dimensions.width > window.innerWidth
          offset.left -= dimensions.width + targetWidth
          @$().addClass('right')
          transformOriginX = "#{dimensions.width - targetWidth + 10}px"

#        if offset.top + dimensions.height > window.innerHeight
#          offset.top -= dimensions.height

        transformOrigin = "#{transformOriginX} 30px"

        @$().css({transformOrigin: transformOrigin, scale: 0})
        @$().css(offset)
        @show()
        $(document.body).bind('mousedown.popup', @onDocumentMouseDown.bind(@))

    mouseDown: (event)->
      event.stopPropagation()

    onDocumentMouseDown: (event)->
      $(document.body).unbind('mousedown.popup')
      @hide()

    onShow: Em.K

    onHide: Em.K

    show: ->
      if @$()
#        $(document.body).scrollTo(@$(), 300, {offset:{top: -100}})
        @$().transition({ scale: 1 }, 300, (=> @onShow()))

    hide: ->
      if @$()
        @$().transition({ scale: 0 }, 300, (=> @onHide(); @destroy()))