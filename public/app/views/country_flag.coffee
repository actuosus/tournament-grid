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
    title: (-> @get 'content.name').property('content')
    hasFlag: (-> !!@get 'content.code').property('content')
    countryFlagClassName: (->
      "country-flag-icon-#{@get 'content.code'}"
    ).property('content.code')