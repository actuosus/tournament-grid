###
 * multilingual_editable_label
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 18:36
###

define [
         'cs!./editable_label'
         'cs!./multilingual_field'
], ->
  App.MultilingualEditableLabel = App.MultilingualField.extend
    classNames: ['multilingual-editable-label']
    fieldView: App.EditableLabel.extend
      valueBinding: 'parentView.value'