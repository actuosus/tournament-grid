###
 * socket
 * @author: actuosus
 * Date: 17/04/2013
 * Time: 23:15
###

define [
  'cs!../core'
  'socket.io'
], ->
  App.SocketController = Em.Controller.extend
    socket: null
    join: ->
      @socket.emit 'join', 'system'

    parseMessage: (string)->
      string.replace /&quot;/g, '"'

    chatted: (message)->
#      {uid: 10, name: "actuosus", message: "Try this", ts: "Wed Jul 03 2013 18:42:23 GMT+0400 (MSK)"}
      JSON.parse @parseMessage message.message

    connect: ->
      if window.socket
        @socket = window.socket
      else
        url = App.config['remote'].socket?.url or document.location.host
        @socket = io.connect url
#      @socket.on 'connect', =>
      @socket.on 'message', (message)=>
        message = @chatted message
        switch message.action
          when 'remove'
            Model = Em.get "App.#{message.model}"
            if Model
              record = App.store.findById Model, message._id
              record.deleteRecord() if record
          when 'update'
            Model = Em.get "App.#{message.model}"
            if Model
              record = App.store.findById Model, message._id
              App.store.reloadRecord record if record
          when 'create'
            Model = Em.get "App.#{message.model}"
            if Model
              record = App.store.findById Model, message._id
              if message.model is 'Player'
                record.didLoad = ->
                  record.get('team').notifyPropertyChange('players')
        console.log message