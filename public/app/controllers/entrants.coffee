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
    search: ->
    searchQuery: ''
    # TODO Filter by player name
    searchByPlayer: no
    arrangedContent: (->
      content = @get 'content'
      searchQuery = @get 'searchQuery'
      if searchQuery
        reg = new RegExp(searchQuery, 'gi')
        result = content.filter (item)->
          name = item.get('name')
          matches = no
          matches = yes if name?.match reg
          matches
      else
        result = content
      result
    ).property('content', 'searchQuery')