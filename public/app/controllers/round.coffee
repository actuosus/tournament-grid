###
 * round
 * @author: actuosus
 * Date: 04/06/2013
 * Time: 23:32
###

define ->
  App.RoundController = Em.ObjectController.extend
    isSelected: no

    save: ->
      content = @get('content')
      unless content
        content = @createRecord()
        @set 'content', content
      content.save()

    deleteRecord: -> @get('content').deleteRecord()

    createRecord: ->
      record = App.Round.createRecord
        sortIndex: @sortIndex
        title: @title
        bracketName: @bracketName
      record.set 'stage', @get 'stage'
      record

    titleChanged: (->
      @get('content')?.set 'title', @title
    ).observes('title')

    setUnknownProperty: (key, value)->
      content = @get 'content'
      console.debug 'Setting property for round proxy', key, content
      unless content
        content = @createRecord()
        @set 'content', content
      content.set key, value

    content: (->
      Em.run.later =>
#        console.log 'sortIndex', @get('sortIndex'), @get('stage.rounds')
        round = @get('stage.rounds')?.find (_)=>
          _.get('sortIndex') is @get('sortIndex') and
            _.get('bracketName') is @get('bracketName')
        @set 'content', round if round
      ,200
      null
    ).property('some', 'stage.rounds.@each.isLoaded')

    some: null

    stageContentIsLoaded: (->
      @set 'some', @get 'stage.sortIndex'
    ).observes('stage.isLoaded')