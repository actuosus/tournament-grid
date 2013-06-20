###
 * round
 * @author: actuosus
 * Date: 04/06/2013
 * Time: 23:32
###

define ->
  App.RoundController = Em.ObjectController.extend
    isSelected: no
    content: null

    save: -> @get('content.store').commit()

    deleteRecord: -> @get('content').deleteRecord()

    createRecord: ->
      record = App.Round.createRecord sortIndex: @sortIndex
      record.set 'stage', @get 'stage'
      record

    setUnknownProperty: (key, value)->
      content = @get 'content'
      console.debug 'Setting property for round proxy', key, content
      unless content
        content = @createRecord()
        @set 'content', content
      content.set key, value