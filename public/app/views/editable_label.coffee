###
 * editable_label
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 09:47
###

define ->
  App.EditableLabel = Em.View.extend
    classNames: ['editable-label']
    template: Em.Handlebars.compile '{{view.value}}'

    click: ->
      @$().attr 'contentEditable', ''

    blur: ->
      @set 'value', @$().text()
      @$().removeAttr 'contentEditable'