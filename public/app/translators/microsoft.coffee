###
 * microsoft
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:22
###

define ['cs!core'],->
  App.MicrosoftTranslator = Em.Object.extend
    isTranslator: yes
    serviceURL: 'http://api.microsofttranslator.com/V2/Ajax.svc'

    checkLanguageSupport: (lang)->
      serviceURL = @get 'serviceURL'
      $.getJSON serviceURL, params

    detect: (text)->
      serviceURL = @get 'serviceURL'
      $.getJSON serviceURL, params

    translate: (fromLang, toLang, text)->

    speak: ->