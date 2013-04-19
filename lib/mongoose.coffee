###
 * mongoose
 * @author: actuosus
 * Date: 18/04/2013
 * Time: 00:33
###

socket = require('../io').getSocket()

socketNotifyPlugin = (schema, options={}) ->
  schema.pre 'save', (next)->
    @_wasNew = @isNew
    next()

  schema.post 'save', (doc)->
    modelName = doc.constructor.modelName
    if @_wasNew
      socket.send {action: 'create', model: modelName, _id: doc._id}
    else
      socket.send {action: 'update', model: modelName, _id: doc._id}

  schema.post 'remove', (doc)->
    console.log doc.constructor
    modelName = doc.constructor.modelName
    socket.send {action: 'remove', model: modelName, _id: doc._id}

# -- exports ----------------------------------------------------------

module.exports = socketNotifyPlugin