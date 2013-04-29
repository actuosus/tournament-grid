###
 * config
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 17:53
###

define ->
  defaults =
    api:
      host: '//virtus-pro.herokuapp.com'
      namespace: 'api'
    languages: ['ru', 'en', 'de']
  $.extend defaults, window.grid.config