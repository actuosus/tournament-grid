###
 * editable_label
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 09:47
###

define ['cs!../core'],->
  App.EditableLabel = Em.View.extend
    classNames: ['editable-label']
    template: Em.Handlebars.compile '{{view.value}}'

    click: ->
      @$().attr 'contentEditable', ''

    focusOut: ->
      @set 'value', @$().text()
      @$().removeAttr 'contentEditable'

#    keyUp: ->
#      @set 'value', @$().text()