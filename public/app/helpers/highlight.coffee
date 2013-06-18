###
 * highlight
 * @author: actuosus
 * Date: 18/06/2013
 * Time: 16:43
###

define ->
  Ember.Handlebars.registerBoundHelper 'highlight', (value, options)->
    if options.hash?.partBinding
      part = options.data.view.get options.hash.partBinding
      re = new RegExp(part, 'gi')
      match = value.match(re)

      if part and match
        value = value.replace re, (substring, position, string)->
          "<span class=\"highlight\">#{substring}</span>"
      else
        value = Handlebars.Utils.escapeExpression value
    else
      value = Handlebars.Utils.escapeExpression value
    new Handlebars.SafeString value