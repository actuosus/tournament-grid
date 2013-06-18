###
 * bitrixed
 * @author: actuosus
 * Date: 16/06/2013
 * Time: 18:51
###

define ->
  App.Bitrixed = Em.Mixin.create
    didInsertElement: ->
      @_super()
      if window.BX
        BX.CPageOpener
        BX.admin.setComponentBorder(@get('elementId')) if window.BX and BX.admin