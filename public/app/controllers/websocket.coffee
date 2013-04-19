###
 * websocket
 * @author: actuosus
 * Date: 17/04/2013
 * Time: 21:01
###

define ['cs!../core'],->
  App.WebSocketController = Em.ObjectController.extend
    websocket: null

    reconnect: -> @connect()

    connect: ->
      @websocket = new WebSocket('ws://tournament.local:8080/');
      @websocket.onopen = (evt)->
        console.log(evt)
      @websocket.onclose = (evt)=>
        console.log(evt)
        @reconnect()
      @websocket.onmessage = (evt)->
        console.log(evt)
        json = JSON.parse evt.data
        if json.action is 'record'
          if json.type is 'view'
            media = App.Media.find(json.data.medisIds)
            if media?.isLoaded
              App.Media.find(json.data.medisIds).set('views', (App.Media.find(json.data.medisIds).get('views') or 0) + 1)
      @websocket.onerror = (evt)->
        console.log(evt)