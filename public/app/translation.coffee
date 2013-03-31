###
 * translation
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 00:24
###

define ['cs!./core'],->
  App.Translation = Em.Object.extend
    isEdited: no

    isLoaded: no
    isAutomaticalyTranslated: no

    sourceLanguage: ''
    targetLanguage: ''

    originalValue: ''
    translatedValue: ''

    value: (->
      @get 'translatedValue'
    ).property('translatedValue')