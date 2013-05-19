###
 * multilingual_field
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:04
###

define ['cs!../mixins/translatable', 'cs!./language_menu'], ->
  App.MultilingualField = Em.ContainerView.extend App.Translatable,
    childViews: ['fieldView', 'languageSelectorView']

    value: null
    languages: []

    automaticTranslation: yes

    provider: null

    selectedLanguage: null

    init: ()->
      @_super()
      @set 'values', new Em.Map()
      @set 'selectedLanguage', App.currentLanguage

    appCurrentLanguageChanged: (->
      @set 'selectedLanguage', App.get('currentLanguage')
    ).observes('App.currentLanguage')

    selectedLanguageChanged: (->
      selectedLanguage = @get 'selectedLanguage'
      console.log 'selectedLanguageChanged', selectedLanguage
      values = @get 'values'
      value = values.get selectedLanguage
#      @set 'value', value
      @set 'fieldView.value', value
    ).observes('selectedLanguage')

    noValueChangeTimer: null
    hasInput: no

    hasInputChanged: (->
      value = @get('value')
      if not @get('hasInput') and value
        @translate value if @get 'automaticTranslation'
    ).observes('hasInput')

    valueChanged: (->
      selectedLanguage = @get 'selectedLanguage'
      values = @get 'values'
      value = @get 'value'
      values.set selectedLanguage, value
      @set 'hasInput', yes
#      if @get 'noValueChangeTimer'
      clearTimeout @get 'noValueChangeTimer'
      @set 'noValueChangeTimer', setTimeout((=> @set 'hasInput', no ),1000)
#      @translate value if @get 'automaticTranslation'
    ).observes('value')

    translationsChanged: (->
      console.log @, 'translationsChanged', @get 'translations'
      translations = @get 'translations'
      values = @get 'values'
      translations.forEach (translation)->
        values.set translation.targetLanguage, translation.get 'value'
    ).observes('translations')

    fieldView: Em.TextField.extend
      classNames: ['text-field']
      attributeBindings: ['required']
      nameBinding: 'parentView.name'
      placeholderBinding: 'parentView.placeholder'
      valueBinding: 'parentView.value'
      requiredBinding: 'parentView.required'

      valueChanged: (->
        value = @get 'value'
        @$().val value
        @$().focus()
      ).observes('value')

    languageSelectorView: Em.ContainerView.extend
      classNames: ['language-selector']
      childViews: ['currentValueView']
      contentBinding: 'parentView.languages'
      selectionBinding: 'parentView.selectedLanguage'
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