###
 * teams
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:37
###

define [
  'cs!../core'
  'cs!../models/team'
  'cs!../views/team/form'
  'cs!../views/entrant/menu_item'
], ->
  App.TeamsController = Em.ArrayController.extend
    formView: App.TeamForm
    searchResults: []
    labelValue: 'name'

    lastQuery: null

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

    fetchAutocompleteResults: (value, target)->
      @set 'lastQuery', {name: value}
      @set 'content', App.Team.find {name: value}
      @set 'autocompleteTarget', target
      @get('content').addObserver 'isLoaded', @, 'contentLoaded'

    cancelFetchingOfAutocompleteResults: ->
      content = @get 'content'
      content.req?.abort()
      content.removeObserver 'isLoaded', @, 'contentLoaded'

    contentLoaded: ->
      @get('content').removeObserver 'isLoaded', @, 'contentLoaded'
      @get('autocompleteTarget').didFetchAutocompleteResults @sort @get('content').toArray(), @get 'lastQuery'

    search: (options)->
      @set 'isLoaded', no
      @set 'content', App.Team.find options

    menuItemViewClass: App.EntrantMenuItem