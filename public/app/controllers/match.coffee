###
 * match
 * @author: actuosus
 * Date: 27/05/2013
 * Time: 18:03
###

define ->
  App.MatchController = Em.ObjectController.extend Ember.Evented,
    isSelected: no
    status: 'opened'
    isVisible: yes

#    entrantsChanged: ((self, property)->
#      content = @get('content')
#      unless content
#        content = App.Match.createRecord()
#        content.set property, @get property
#        content.set 'sortIndex', @get 'sortIndex'
#        content.set 'round', @get 'round.content'
#        @set 'content', content
#    ).observes('entrant1', 'entrant2')

    open: ->
      content = @get('content')
      content.open() if content

    close: ->
      content = @get('content')
      content.close() if content

    save: -> @get('content.store').commit()
    edit: ->
      popup = App.PopupView.create target: @
      popup.pushObject(
        App.MatchForm.create
          popupView: popup
          match: @get('content')
          content: @get('content')
          title: @get 'match.title'
          description: @get 'match.description'
          didUpdate: => popup.hide()
      )
      popup.appendTo App.get 'rootElement'

    deleteRecord: -> @get('content').deleteRecord()

    createRecord: ->
      record = App.Match.createRecord
        sortIndex: @sortIndex
        status: 'opened'
      round = @get 'round.content'
      unless round
        round = @get('round').createRecord()
      record.set 'round', round
      round.get('matches').addObject record
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
        match = @get('round.content.matches')?.find (_)=>_.get('sortIndex') is @get('sortIndex')
        if match
          if @get 'isFinal'
            @set('entrants', [match.get('entrants').objectAt 0])
          else
            @set('entrants', match.get('entrants'))
          if @get('round.itemIndex') is 0
            # Third place playoff
            if match.get('sortIndex') is 1
              @set 'isVisible', yes
          @set 'content', match
          @trigger 'didLoad'
          @onLoaded()
      ,200
      null
    ).property('some', 'round.content.matches.@each.isLoaded')

    onLoaded: Em.K

    some: null

    roundContentIsLoaded: (->
      @set 'some', @get 'round.index'
    ).observes('round.content.isLoaded')