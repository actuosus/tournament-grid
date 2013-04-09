###
 * number
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 14:20
###

define [
  'cs!../core'
  'cs!./editable_label'
],->
  App.NumberView = App.EditableLabel.extend
    tagName: 'span'
    classNames: ['number']

    value: null

    template: Em.Handlebars.compile '{{view.value}}'

    step: 1
    min: 0
    max: 100

    increment: ->
      value = @get 'value'
      newValue = value + @get('step')
      if newValue >= @get('min') and newValue <= @get('max')
        @incrementProperty 'value', @get 'step'

    decrement: ->
      value = @get 'value'
      newValue = value - @get('step')
      if newValue >= @get('min') and newValue <= @get('max')
        @incrementProperty 'value', -@get 'step'

    mouseWheel: (event)->
      if @get 'isEditable'
        event.preventDefault()
        if event.originalEvent.wheelDelta > 0
          @increment()
        else
          @decrement()

    keyDown: (event)->
      if @get 'isEditable'
        switch event.keyCode
          when 40 # down
            event.preventDefault()
            @decrement()
          when 38 # up
            event.preventDefault()
            @increment()


    setValue: (value)->
      value = parseFloat(value)
      @set('value', value) if @get('value') isnt value