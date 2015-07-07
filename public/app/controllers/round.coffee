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
      record = App.store.createRecord 'round',
        sortIndex: @sortIndex
        title: @title
        bracketName: @bracketName
        stage: @get 'stage'
#      record.set 'stage', @get 'stage'
      record

    contentIsLoaded: (->
      round = @get('stage.rounds')?.find (_)=>
        console.log(_.get('currentState.stateName'), _.get('sortIndex'), _.get('bracketName'))
        _.get('sortIndex') is @get('sortIndex') and _.get('bracketName') is @get('bracketName')
      if round
        console.log 'Will set round for', round
        @set('content', round)
    ).observes('stage.rounds.@each.currentState.stateName')

#     setUnknownProperty: (key, value)->
#       content = @get 'content'
#       unless content
#         content = @createRecord()
#         @set 'content', content
#       content.set key, value

#     content: (->
#       Em.run.later =>
#         round = @get('stage.rounds')?.find (_)=>
#           _.get('sortIndex') is @get('sortIndex') and
#             _.get('bracketName') is @get('bracketName')
#         @set('content', round) if round
#       ,200
#       null
#     ).property('some', 'stage.rounds.@each.isLoaded', 'content.isLoaded')
