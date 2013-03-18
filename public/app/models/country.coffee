###
 * country
 * @author: actuosus
 * @fileOverview Country model.
 * Date: 21/01/2013
 * Time: 07:28
###

define ->
  App.Country = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    englishName: DS.attr 'string'
    germanName: DS.attr 'string'
    code: DS.attr 'string'

    flagClassName: Em.computed ->
      'country-flag-icon-%@'.fmt @get 'code'
    flagURL: Em.computed ->
      '/vendor/images/famfamfam_flag_icons/png/%@.png'.fmt @get 'code'

#    adapter: 'DS.FixtureAdapter'

  App.Country.toString = -> 'Country'