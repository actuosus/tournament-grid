###
 * date_field
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 04:50
###

define ['cs!../core'],->
  App.DateField = Em.TextField.extend
#    type: 'date'
    didInsertElement: ->
      @$().datepicker( $.datepicker.regional[App.get('currentLanguage')])
      @$().datepicker 'option', 'dateFormat', 'dd.mm.yy'