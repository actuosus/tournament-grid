###
 * multilingual_editable_label
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 18:36
###

define [
         'cs!views/editable_label'
         'cs!views/multilingual_field'
], ->
  App.MultilingualEditableLabel = App.MultilingualField.extend
    classNames: ['multilingual-editable-label']
    fieldView: App.EditableLabel.extend
      valueBinding: 'parentView.value'