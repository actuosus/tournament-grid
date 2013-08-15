###
 * config
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 17:53
###

define ['jquery'], ->
  defaults =
    api:
#      host: '//virtus-pro.herokuapp.com'
      namespace: 'api'
    languages: ['ru', 'en', 'de']
    currentLanguage: null
  if window.grid?.config
    config = $.extend defaults, window.grid.config
  else
    config = defaults
  config