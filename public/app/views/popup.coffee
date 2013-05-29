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

    origin: null

    showCloseButton: no

    childViews: ['arrowBorderView', 'arrowView', 'closeButtonView']

    arrowView: Em.View.extend
      classNames: ['popup-arrow']

    arrowBorderView: Em.View.extend
      classNames: ['popup-arrow-border']

    closeButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'popup-close-button']
      template: Em.Handlebars.compile '×'
      isVisibleBinding: 'parentView.showCloseButton'
      click: -> @get('parentView').hide()

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
      origin = @get('origin')
      dimensions = width: element.offsetWidth, height: element.offsetHeight
#      targetDimensions = width: targetElement.offsetWidth, height: targetElement.offsetHeight
#      console.log dimensions
      if target
        offset = target.$().offset()
        targetWidth = target.$().width()
        targetHeight = target.$().height()

        # Right
        offset.left += targetWidth
        offset.top += targetHeight/2 - 30

        transformOriginX = '-10px'

        if origin is 'center'
          offset.left -= targetWidth/2 + dimensions.width/2
          offset.top += targetHeight/2 - dimensions.height/2
          transformOriginX = "#{targetWidth/2}"
        else if origin is 'top'
          offset = target.$().offset()
          # Centered horizontaly
          offset.left += targetWidth/2 - dimensions.width/2
          offset.top -= dimensions.height
          transformOriginX = "#{targetWidth/2}"
        else if offset.left + dimensions.width > window.innerWidth
          offset.left -= dimensions.width + targetWidth
          @$().addClass('right')
          transformOriginX = "#{dimensions.width - targetWidth + 10}px"

        transformOrigin = "#{transformOriginX} 30px"

        @$().css({transformOrigin: transformOrigin, scale: 0})
        @$().css(offset)
        $(document.body).bind('mousedown.popup', @onDocumentMouseDown.bind(@))
        @show()
      else
        # Without target it's floatable
        @$().css 'position', 'fixed'
        @$().css 'right', 100
        @$().css 'top', '50%'
        @show()

    mouseDown: (event)->
      event.stopPropagation()

    onDocumentMouseDown: (event)->
      $(document.body).unbind('mousedown.popup')
      @hide()

    onShow: Em.K
    onHide: Em.K

    show: (args)->
      if @$()
#        $(document.body).scrollTo(@$(), 300, {offset:{top: -100}})
        @$().transition({ scale: 1 }, 300, (=> @onShow(args)))

    hide: (args)->
      if @$()
        @$().transition({ scale: 0 }, 300, (=> @onHide(args); @destroy()))