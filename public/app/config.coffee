###
 * config
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 17:53
###

define ->
  defaults =
    api:
      host: 'future-is-here.herokuapp.com'
      namespace: 'api'
    apiNamespace: 'api'
    languages: ['ru', 'en', 'de']
  $.extend defaults, window.gridConfig