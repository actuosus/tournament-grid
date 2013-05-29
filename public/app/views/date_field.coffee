###
 * date_field
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 04:50
###

define ['cs!../core'],->
  App.DateField = Em.TextField.extend
    type: 'date'

    _valueChanged: (->
      @set 'rawDate', date
    ).observes('value')