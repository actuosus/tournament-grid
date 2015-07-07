###
 * moment
 * @author: actuosus
 * Date: 18/06/2013
 * Time: 16:44
###

define ->
  Ember.Handlebars.registerBoundHelper 'moment', (value, options)->
    new Em.Handlebars.SafeString moment(value).format(options.hash.format)