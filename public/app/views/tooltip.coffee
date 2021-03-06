###
 * tooltip
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 13:53
###

define ->
  App.TooltipView = Em.ContainerView.extend
    classNames: ['popup']

    target: null,

    childViews: ['arrowBorderView', 'arrowView'],

    arrowView: Em.View.extend
      classNames: ['popup-arrow']

    arrowBorderView: Em.View.extend
      classNames: ['popup-arrow-border']

    didInsertElement: ->
      @_super()
      target = @get('target')
      if target
        @$().css({transformOrigin: '-10px 30px', scale: 0})
        offset = target.$().offset()
        targetWidth = target.$().width()
        targetHeight = target.$().height()
        offset.left += targetWidth
        offset.top += targetHeight/2 - 30
        @$().css(offset)
        @show()
        $(document.body).bind('mousedown.popup', @onDocumentMouseDown.bind(@))

    mouseDown: (event)->
      event.stopPropagation()

    onDocumentMouseDown: (event)->
      $(document.body).unbind('mousedown.popup')
      @hide()

    show: ->
      @$().transition({ scale: 1 }, 300)

    hide: ->
      @$().transition({ scale: 0 }, 300, (-> @destroy()).bind(@))