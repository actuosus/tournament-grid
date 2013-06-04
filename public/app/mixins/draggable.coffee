###
 * draggable
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 06:19
###

define ->
  App.Draggable = Em.Mixin.create
    attributeBindings: 'draggable'
    draggable: 'true'

    mouseDown: (event)->
      event.stopPropagation()

    dragStart: (event)->
      dataTransfer = event.originalEvent.dataTransfer
      dataTransfer.setData 'Text', @get 'elementId'