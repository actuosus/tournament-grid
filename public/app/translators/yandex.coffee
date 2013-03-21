###
 * yandex
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:23
###

define ->
  App.YandexTranslator = Em.Object.extend
    isTranslator: yes
    serviceURL: 'http://translate.yandex.net/api/v1/tr.json/translate?callback=?'

    checkLanguageSupport: (lang)->
      serviceURL = @get 'serviceURL'
      $.getJSON serviceURL, params

    detect: (text)->

    translate: (fromLang, toLang, text, cb)->
      serviceURL = @get 'serviceURL'
      params =
        text: text
        lang: "#{fromLang}-#{toLang}"
      $.getJSON serviceURL, params, (data)=> @_didFetchTranslation data, cb

    didFetchTranslation: Em.K

    _didFetchTranslation: (data, cb)->
      console.log data
      cb data.text[0]
