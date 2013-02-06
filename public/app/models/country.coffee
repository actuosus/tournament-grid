###
 * country
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:28
###

define ->
  App.Country = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    code: DS.attr 'string'

    flagURL: Em.computed ->
      '/vendor/images/famfamfam_flag_icons/png/%@.png'.fmt @get 'code'

  App.Country.toString = -> 'Country'