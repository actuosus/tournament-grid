###
 * translatable
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:15
###

define ['cs!translation'], ->
  App.Translatable = Ember.Mixin.create
    selectedLanguage: null
    selectedProvider: null

    languages: []
    providers: []

    translations: []

    translatedValues: {}

#    _valueChanged: (
#
#    ).observes('value')

    translate: (value)->
      return unless value
      translatedValues = @get 'translatedValues'
      return translatedValues[value] if translatedValues[value]
      selectedLanguage = @get 'selectedLanguage'
      unless selectedLanguage
        selectedLanguage = App.currentLanguage
      languages = @get 'languages'
      provider = @get 'selectedProvider'
      unless provider
        provider = App.YandexTranslator.create()
        @set 'selectedProvider', provider
      translations = @get 'translations'
      languages.forEach (language)=>
        unless language is selectedLanguage
          provider.translate selectedLanguage, language, value, (translation)=>
            trans = App.Translation.create
              isAutomaticalyTranslated: yes
              isLoaded: yes

              sourceLanguage: selectedLanguage
              targetLanguage: language
              originalValue: value
              translatedValue: translation
            translatedValues[value] = trans
            translations.push trans

            @notifyPropertyChange('translations')