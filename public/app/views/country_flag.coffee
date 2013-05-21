###
 * country_flag
 * @author: actuosus
 * Date: 19/05/2013
 * Time: 21:56
###

define ->
  App.CountryFlagView = Em.View.extend
    tagName: 'i'
    classNames: ['country-flag-icon', 'team-country-flag-icon']
    classNameBindings: ['countryFlagClassName', 'hasFlag']
    attributeBindings: ['title']
    title: (-> @get 'content.country.name').property('content.country')
    hasFlag: (-> !!@get 'content.country.code').property('content.country')
    countryFlagClassName: (->
      "country-flag-icon-#{@get 'content.country.code'}"
    ).property('content.country.code')