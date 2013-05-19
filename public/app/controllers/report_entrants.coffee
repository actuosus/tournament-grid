###
 * report_entrants
 * @author: actuosus
 * Date: 14/05/2013
 * Time: 18:55
###

define ->
  App.ReportEntrantsController = Em.ArrayController.extend
    searchResults: []

    search: (options)->
      @set 'searchQuery', options.name

    searchPath: 'team.name'
    searchQuery: ''
    searchByPlayer: no

    arrangedContent: (->
      content = @get 'content'
      searchQuery = @get 'searchQuery'
      searchPath = @get 'searchPath'
      #      console.log searchQuery
      if searchQuery
        reg = new RegExp searchQuery, 'gi'
        result = content.filter (item)->
          name = item.get searchPath
          matches = no
          matches = yes if name?.match reg
          matches
      else
        result = content
      result
    ).property('content', 'searchQuery')
