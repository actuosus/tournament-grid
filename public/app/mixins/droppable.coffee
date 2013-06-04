###
 * droppable
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 06:23
###

define ->
  App.Droppable = Em.Mixin.create
    dragEnter: (event)->
      event.preventDefault()
      no
    dragOver: (event)->
      event.preventDefault()
      no
#    drop: -> console.log 'drop'