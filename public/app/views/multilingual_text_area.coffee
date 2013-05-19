###
 * multilingual_text_area
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:05
###

define ['cs!./multilingual_field'], ->
  App.MultilingualTextArea = App.MultilingualField.extend
    classNames: ['multilingual-text-area']

    fieldView: Em.TextArea.extend
      classNames: ['text-area']
      attributeBindings: ['required']
      nameBinding: 'parentView.name'
      placeholderBinding: 'parentView.placeholder'
      valueBinding: 'parentView.value'
      rowsBinding: 'parentView.rows'
      colsBinding: 'parentView.cols'
      requiredBinding: 'parentView.required'
      valueChanged: (->
        value = @get 'value'
        if @$()
          @$().val value
          @$().focus()
      ).observes('value')