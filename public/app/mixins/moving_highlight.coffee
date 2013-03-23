###
 * moving_highlight
 * @author: actuosus
 * Date: 23/03/2013
 * Time: 03:26
###

define ->
  App.MovingHightlight = Ember.Mixin.create

    mouseEnter: (event)->
      @_originalBackground = @$().css 'background-color'

    mouseMove: (event)->
      gradientSize = 100
      lightColor = "rgba(255,255,255,0.75)"
      offset = @$().offset()
      x  = event.pageX - offset.left
      y  = event.pageY - offset.top
      xy = x + " " + y

      backgroundWebKit = "-webkit-gradient(radial, " + xy + ", 0, " + xy + ", " + gradientSize + ", from(" + lightColor + "), to(rgba(255,255,255,0.0))), " + @_originalBackground
      backgroundMozilla    = "-moz-radial-gradient(" + x + "px " + y + "px 45deg, circle, " + lightColor + " 0%, " + @_originalBackground + " " + gradientSize + "px)"

      @$().css(background: backgroundWebKit).css(background: backgroundMozilla)

    mouseLeave: ->
      @$().css background: @_originalBackground
