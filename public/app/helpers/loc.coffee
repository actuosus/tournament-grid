###
 * loc
 * @author: actuosus
 * Date: 18/06/2013
 * Time: 16:43
###

define ->
  ###
   * Localization Handlebars helper.
  ###
  Em.Handlebars.registerHelper 'loc', (property, fn)->
    if fn.contexts and typeof fn.contexts[0] is 'string'
      str = fn.contexts[0]
    else if property[0] is '_'
      str = property
    else if /[A-Z]/.test property[0]
      str = Em.get window, property
    else
      str = this.get property
    new Handlebars.SafeString (str || '').loc('')