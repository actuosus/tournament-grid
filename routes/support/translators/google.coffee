###
 * google
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 00:59
###

superagent = require 'superagent'

class GoogleTranslator
  serviceURL: ''
  translate: (source, target, text)->