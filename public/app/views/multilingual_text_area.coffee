###
 * multilingual_text_area
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 22:05
###

define ['cs!views/multilingual_field'], ->
  App.MultilingualTextArea = App.MultilingualField.extend
    classNames: ['multilingual-text-area']

    textFieldView: Em.TextArea.extend
      classNames: ['text-area']
      nameBinding: 'parentView.name'
      placeholderBinding: 'parentView.placeholder'
      valueBinding: 'parentView.value'
      rowsBinding: 'parentView.rows'
      colsBinding: 'parentView.cols'
      valueChanged: (->
        value = @get 'value'
        @$().val value
        @$().focus()
      ).observes('value')