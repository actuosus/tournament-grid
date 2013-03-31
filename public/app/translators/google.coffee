###
 * google
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:22
###

define ['cs!../core'],->
  App.GoogleTranslator = Em.Object.extend
    isTranslator: yes
    serviceURL: 'https://www.googleapis.com/language/translate/v2?callback=?'

    key: ''

    checkLanguageSupport: (lang)->
      serviceURL = @get 'serviceURL'
      $.getJSON serviceURL, params

    detect: (text)->
      serviceURL = @get 'serviceURL'
      $.getJSON serviceURL, params

    translate: (fromLang, toLang, text)->
      serviceURL = @get 'serviceURL'
      key = @get 'key'
      params =
        key: key
        source: fromLang
        target: toLang
        q: text
      $.getJSON serviceURL, params