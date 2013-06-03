###
 * multilingual_text_field
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 20:43
###

define ['cs!./multilingual_field'], ->
  App.MultilingualTextField = App.MultilingualField.extend
    classNames: ['multilingual-text-field']

    fieldView: Em.TextField.extend
      classNames: ['text-field']
      attributeBindings: ['required']
      nameBinding: 'parentView.name'
      placeholderBinding: 'parentView.placeholder'
      sizeBinding: 'parentView.size'
      patternBinding: 'parentView.pattern'
      requiredBinding: 'parentView.required'
      valueBinding: 'parentView.value'

      valueChanged: (->
        value = @get 'value'
        if @$()
          @$().val value
          @$().focus()
      ).observes('value')