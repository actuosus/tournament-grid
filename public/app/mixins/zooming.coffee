###
 * zooming
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 15:04
###

define ->
  App.Zooming = Ember.Mixin.create
    willInsertElement: ->
      buffer = @get('buffer')
      if buffer
        element = buffer.element()
        if element
          element.style.webkitTransform = 'scale(0)'
          element.style.webkitTransitionDuration = '0.3s'
          element.style.webkitTransitionProperty = '-webkit-transform'
    didInsertElement: ->
      element = @get 'element'
      setTimeout((->element.style.webkitTransform = 'scale(1)'), 100) if element