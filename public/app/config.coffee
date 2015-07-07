###
 * config
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 17:53
###

define ['jquery'], ->
  defaults =
    authUrl: '/API/reportage/auth.php'
    api:
#      host: '//virtus-pro.herokuapp.com'
#      host: 'http://virtuspro.local:8001'
#      host: 'http://develop.virtus.pro'
#      host: 'http://virtus.pro'
      namespace: 'api'
    remote: authUrl: '/auth'
    languages: ['ru', 'en', 'de']
    currentLanguage: null
  if window.grid?.config
    config = $.extend defaults, window.grid.config
  else
    config = defaults
  config