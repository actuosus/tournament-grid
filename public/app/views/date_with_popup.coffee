###
 * date_with_popup
 * @author: actuosus
 * Date: 21/05/2013
 * Time: 14:05
###

define ->
  App.DateWithPopupView = Em.View.extend
    classNames: ['date-with-popup']
    template: Em.Handlebars.compile '{{view.value}}'
    attributeBindings: ['title']

    dateFormat: ''
    timeFormat: ''
    format: 'DD.MM.YY HH:mm:ss'
    titleFormat: 'DD.MM.YY HH:mm:ss'

    showPopup: yes

    title: (->
      date = @get 'content'
      if date
        moment(date).format @get 'titleFormat'
      else
        ''
    ).property('content')

    value: (->
      date = @get 'content'
      if date
        moment(date).format @get 'format'
      else
        ''
    ).property('content')

    click: ->
      return unless @get 'showPopup'
      dateView = @
      date = @get 'content'
      @popup = App.PopupView.create target: @
      @picker = Em.View.create
        willInsertElement: ->
          $el = @$()
          @$().datetimepicker
            dateFormat: 'dd.mm.yy'
            timeFormat: 'HH:mm:ss'
            showAnim: 'show'
            showButtonPanel: no
            beforeShow: (input, inst)-> console.log inst
            onClose: -> dateView.popup.hide()
            onSelect: -> dateView.set 'content', $el.datetimepicker 'getDate'
          @$().datetimepicker 'setDate', date if date
        willDestroyElement: -> @$().datetimepicker 'destroy'
      @popup.pushObject @picker
      @popup.append()