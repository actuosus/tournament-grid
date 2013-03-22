###
 * config
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 17:53
###

define ->
  defaultGridConfig =
    apiNamespace: 'api'
    languages: ['ru', 'en', 'de']
  $.extend defaultGridConfig, window.gridConfig