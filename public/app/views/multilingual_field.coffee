###
 * multilingual_field
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:04
###

define ['cs!mixins/translatable', 'cs!views/language_menu'], ->
  App.MultilingualField = Em.ContainerView.extend App.Translatable,
    childViews: ['textFieldView', 'languageSelectorView']

    value: null
    values: []
    languages: []

    automaticTranslation: yes

    provider: null

    selectedLanguage: null

    initMixin: ->
      console.log arguments

    selectedLanguageChanged: (->
      languages = @get 'languages'
      selectedLanguage = @get 'selectedLanguage'
      console.log 'selectedLanguageChanged', selectedLanguage
      languageIndex = languages.indexOf selectedLanguage
      values = @get 'values'
      value = values.objectAt languageIndex
#      @set 'value', value
      @set 'textFieldView.value', value
    ).observes('selectedLanguage')

    noValueChangeTimer: null
    hasInput: no

    hasInputChanged: (->
      value = @get('value')
      if not @get('hasInput') and value
        @translate value if @get 'automaticTranslation'
    ).observes('hasInput')

    valueChanged: (->
      languages = @get 'languages'
      selectedLanguage = @get 'selectedLanguage'
      languageIndex = languages.indexOf selectedLanguage
      values = @get 'values'
      value = @get 'value'
      values[languageIndex] = value
      @set 'hasInput', yes
#      if @get 'noValueChangeTimer'
      clearTimeout @get 'noValueChangeTimer'
      @set 'noValueChangeTimer', setTimeout((=> @set 'hasInput', no ),1000)
#      @translate value if @get 'automaticTranslation'
    ).observes('value')

    translationsChanged: (->
      console.log 'translationsChanged', @get 'translations'
      translations = @get 'translations'
      languages = @get 'languages'
      values = @get 'values'
      translations.forEach (translation)->
        languageIndex = languages.indexOf translation.targetLanguage
        values[languageIndex] = translation.get 'value'
    ).observes('translations')

    textFieldView: Em.TextField.extend
      classNames: ['text-field']
      nameBinding: 'parentView.name'
      placeholderBinding: 'parentView.placeholder'
      valueBinding: 'parentView.value'

      valueChanged: (->
        value = @get 'value'
        @$().val value
        @$().focus()
      ).observes('value')

    languageSelectorView: Em.ContainerView.extend
      classNames: ['language-selector']
      childViews: ['currentValueView']
      contentBinding: 'parentView.languages'
      selection: null
      selectionChanged: (->
        selection = @get 'selection'
        content = @get 'content'
        childViews = @get 'childViews'
        selectionContentIndex = content.indexOf selection
        @set 'parentView.selectedLanguage', selection
        childViews.forEach (view, idx)->
          if selectionContentIndex is idx
            view.set('isSelected', yes)
          else
            view.set('isSelected', no)
      ).observes('selection')
      currentValueView: Em.View.extend
        classNames: 'current-value'
        template: Em.Handlebars.compile '{{view.value}}'
        valueBinding: 'parentView.selection'
        mouseEnter: ->
          menu = App.LanguageMenuView.create
            target: @
            parentView: @get 'parentView'
          menu.append()
        mouseLeave: ->

      providersView: Em.View.extend()