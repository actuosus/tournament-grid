###
 * entrants
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:34
###

define [
  'cs!../core'
], ->
  App.EntrantsController = Em.ArrayController.extend
    searchResults: []

    search: (options)->
      @set 'searchQuery', options.name

    searchPath: 'team.name'
    searchQuery: ''
    # TODO Filter by player name
    searchByPlayer: no

    searchQueryChanged: (->
      content = @get 'content'
      searchQuery = @get 'searchQuery'
      searchPath = @get 'searchPath'
      if searchQuery
        reg = new RegExp searchQuery, 'gi'
        result = content.filter (item)->
          name = item.get searchPath
          matches = no
          matches = yes if name?.match reg
          matches
      else
        result = content
      @get('the').pushObjects result
    ).observes('content', 'arrangedContent', 'searchQuery')

    arrangedContent: Em.computed.alias 'the'