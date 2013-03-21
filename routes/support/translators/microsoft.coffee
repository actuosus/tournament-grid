###
 * microsoft
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 00:59
###

superagent = require 'superagent'

class MicrosoftTranslator
  serviceURL: ''
  translate: (source, target, text)->