###
 * yandex
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:23
###

define ['cs!../core'],->
  App.YandexTranslator = Em.Object.extend
    isTranslator: yes
    key: 'trnsl.1.1.20140429T210433Z.906e1146e2ee756f.36dffc2d35c3b9427284d9a2c5a3b0eed62cbd3b'
    serviceURL: 'https://translate.yandex.net/api/v1.5/tr.json/translate?callback=?'

    checkLanguageSupport: (lang)->
      serviceURL = @get 'serviceURL'
      $.getJSON serviceURL, params

    detect: (text)->

    translate: (fromLang, toLang, text, cb)->
      serviceURL = @get 'serviceURL'
      key = @get 'key'
      params =
        key: key
        text: text
        lang: "#{fromLang}-#{toLang}"
      $.getJSON serviceURL, params, (data)=> @_didFetchTranslation data, cb

    didFetchTranslation: Em.K

    _didFetchTranslation: (data, cb)->
      cb data?.text?[0]
