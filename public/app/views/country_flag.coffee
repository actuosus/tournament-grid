###
 * country_flag
 * @author: actuosus
 * Date: 19/05/2013
 * Time: 21:56
###

define ->
  App.CountryFlagView = Em.View.extend
    tagName: 'img'
    classNames: ['country-flag-icon', 'team-country-flag-icon', 'b-flag']
    classNameBindings: ['countryFlagClassName', 'hasFlag']
    # attributeBindings: ['title']
    # title: Em.computed.alias 'content.name'
    hasFlag: Em.computed.notEmpty 'content.code'
    countryFlagClassName: (->
#      "country-flag-icon-#{@get 'content.code'}"
      "b-flag_#{@get 'content.code'}"
    ).property('content.code')