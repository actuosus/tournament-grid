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
    connect: ->
      port = 8080
      @socket = io.connect "#{document.location.hostname}:#{port}"
      @socket.on 'connect', =>
        @socket.on 'message', (message)->
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