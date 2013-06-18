###
 * _loc
 * @author: actuosus
 * Date: 18/06/2013
 * Time: 16:43
###

define ->
  Em.Handlebars.registerBoundHelper '_loc', (value, options)->
    if options.contexts and typeof options.contexts[0] is 'string'
      str = options.contexts[0]
    else if typeof value is 'object'
      str = value[App.currentLanguage]
    else if value is '_'
      str = value
    else if /[A-Z]/.test value
      str = Em.get window, value
    else
      str = this.get "_#{value}.#{App.currentLanguage}"
    new Handlebars.SafeString (str || '').loc('')