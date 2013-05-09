###
 * editable_label
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 09:47
###

define ['cs!../core'],->
  App.EditableLabel = Em.View.extend
    classNames: ['editable-label']
    classNameBindings: ['isEmpty', 'isEditable']
#    template: Em.Handlebars.compile '{{view.value}}'
    isEditable: yes

    valueType: 'text'

    value: null

    isEmpty: (-> !@get('value')).property('value')

    didInsertElement: ->
      switch @get 'valueType'
        when 'text'
          @$().text(@get 'value')
        when 'html'
          @$().html(@get 'value')

    isEditableChanged: (->
      unless @get 'isEditable'
        @$().removeAttr 'contentEditable'
        @$().removeAttr 'tabIndex'
    ).observes('isEditable')

    click: ->
      if @get 'isEditable'
        @$().attr 'contentEditable', ''
        @$().attr 'tabIndex', 0
        @$().focus()
        @$().select()

    mouseEnter: ->
      if @get 'isEditable'
        @$().addClass('active')

    mouseLeave: ->
      if @get 'isEditable'
        @$().removeClass('active')

    focusIn: ->
      @set 'hasFocus', yes
#      @$().select()

    focusOut: ->
      @set 'hasFocus', no
      if @get 'isEditable'
        switch @get 'valueType'
          when 'text'
            value = @$().text()
          when 'html'
            value = @$().html()

        @setValue (value)
        @$().removeAttr 'contentEditable'

    setValue: (value)->
      @set('value', value) if @get('value') isnt value

    _valueChanged: (->
      if @$()
        switch @get 'valueType'
          when 'text'
            @$().text(@get 'value')
          when 'html'
            @$().html(@get 'value')
    ).observes('value')


#    keyUp: ->
#      @set 'value', @$().text()