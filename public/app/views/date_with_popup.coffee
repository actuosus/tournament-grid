###
 * date_with_popup
 * @author: actuosus
 * Date: 21/05/2013
 * Time: 14:05
###

define ->
  App.DateWithPopupView = Em.View.extend
    tagName: 'span'
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
      if date and moment(date).isValid()
        moment(date).format @get 'titleFormat'
      else
        ''
    ).property('content')

    value: (->
      date = @get 'content'
      if date and moment(date).isValid()
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
            timeFormat: 'HH:mm'
            showAnim: 'show'
            showButtonPanel: no
            onClose: -> dateView.popup.hide()
#            onSelect: -> dateView.set 'content', $el.datetimepicker 'getDate'
          @$().datetimepicker 'setDate', date if date
        willDestroyElement: -> @$().datetimepicker 'destroy'
      @okButton = Em.View.create
        tagName: 'button'
        classNames: ['btn', 'btn-primary']
        attributeBindings: ['title']
        title: '_ok'.loc()
        template: Em.Handlebars.compile '{{ loc "_ok" }}'
        click: ->
          dateView.set 'content', dateView.picker.$().datetimepicker 'getDate'
          dateView.popup.hide()
      @popup.pushObject @picker
      @popup.pushObject @okButton
      @popup.appendTo App.get 'rootElement'