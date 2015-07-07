###
 * countries
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:35
###

define [
  'ehbs!countrySelectCurrentValue'
  'cs!../core'
],->
  App.CountriesController = Em.ArrayController.extend
    model: []
    searchResults: []
    labelValue: 'name'
    sort: (result, options)->
      lowerCased = options.name.toLowerCase()
      result.sort (a,b)->
        lowerA = a.get('name').toLowerCase()
        lowerB = b.get('name').toLowerCase()
        if lowerA.indexOf(lowerCased) < lowerB.indexOf(lowerCased)
          return -1
        if lowerA.indexOf(lowerCased) > lowerB.indexOf(lowerCased)
          return 1
        if lowerA.indexOf(lowerCased) is lowerB.indexOf(lowerCased)
          return 0
    all: ->
      @set 'content', App.countries
      @set 'content.isLoaded', yes
      @notifyPropertyChange('content.isLoaded')

    showAll: (target)->
      @set 'autocompleteTarget', target
      @get('autocompleteTarget').didFetchAutocompleteResults App.countries

    filterWithQuery: (query)->
      return unless App.countries
      result = App.countries.filter (item, idx)->
        regexp = new RegExp query, 'i'
        return yes if item.get('name')?.match regexp
        return yes if item.get('__name')?.match regexp
        return yes if item.get('englishName')?.match regexp

      @sort result, {name: query}

    search: (options)->
      return unless App.countries
      result = App.countries.filter (item, idx)->
        regexp = new RegExp(options.name, 'i')
        #          if item.get('_name')
        if item.get('name')?.match regexp
          return yes
        if item.get('__name')?.match regexp
          return yes
        if item.get('englishName')?.match regexp
          return yes
      @set 'content', @sort(result, options)
      @set 'content.isLoaded', yes


    cancelFetchingOfAutocompleteResults: ->

    fetchAutocompleteResults: (value, target)->
      @set 'autocompleteTarget', target
      @get('autocompleteTarget').didFetchAutocompleteResults @filterWithQuery value

    menuItemViewClass: Em.View.extend
      classNames: ['menu-item', 'country-menu-item']
      classNameBindings: ['isSelected']
      templateName: 'countrySelectCurrentValue'

      mouseDown: (event)-> event.stopPropagation()

      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').selectMenuItem? @get 'content'
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @set 'parentView.isVisible', no