###
 * date_field
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 04:50
###

define ['cs!../core'],->
  App.DateField = Em.TextField.extend
#    type: 'date'
    rawDate: null

    didInsertElement: ->
#      @$().datetimepicker( $.datepicker.regional[App.get('currentLanguage')])
      $.timepicker.setDefaults($.timepicker.regional[App.get('currentLanguage')]);
      @$().datetimepicker
        dateFormat: 'dd.mm.yy'
        timeFormat: 'HH:mm:ss'
#        beforeShow: (input, inst)-> inst.dpDiv.css 'z-index': 2
      @$().datetimepicker 'option', $.datepicker.regional[App.get('currentLanguage')]

    _valueChanged: (->
      date = @$().datepicker 'getDate'
      @set 'rawDate', date
#      @set 'content', date
    ).observes('value')