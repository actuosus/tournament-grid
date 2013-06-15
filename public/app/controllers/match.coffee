###
 * match
 * @author: actuosus
 * Date: 27/05/2013
 * Time: 18:03
###

define ->
  App.MatchController = Em.ObjectController.extend
    isSelected: no

#    entrantsChanged: ((self, property)->
#      content = @get('content')
#      unless content
#        content = App.Match.createRecord()
#        content.set property, @get property
#        content.set 'sort_index', @get 'sort_index'
#        content.set 'round', @get 'round.content'
#        @set 'content', content
#    ).observes('entrant1', 'entrant2')

    open: ->
      content = @get('content')
      content.open() if content

    close: ->
      content = @get('content')
      content.close() if content

    createRecord: ->
      record = App.Match.createRecord sort_index: @sort_index
      round = @get 'round.content'
      unless round
        round = @get('round').createRecord()
      record.set 'round', round
      record

    setUnknownProperty: (key, value)->
      content = @get 'content'
      console.debug 'Setting property for match proxy', key, content
      unless content
        content = @createRecord()
        @set 'content', content
      content.set key, value

    content: (->
      Em.run.later =>
        match = @get('round.content.matches')?.objectAtContent @get 'sort_index'
        @set('entrants', match.get('entrants')) if match
        @set 'content', match if match
      ,1000
      null
    ).property('some', 'round.content.matches.@each.isLoaded')

    some: null

    roundContentIsLoaded: (->
      @set 'some', @get 'round.index'
    ).observes('round.content.isLoaded')