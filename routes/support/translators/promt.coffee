###
 * promt
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 00:58
###

superagent = require 'superagent'

class PromtTranslator
  serviceURL: ''
  translate: (source, target, text)->