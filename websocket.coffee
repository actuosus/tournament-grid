###
 * websocket
 * @author: actuosus
 * Date: 17/04/2013
 * Time: 21:03
###

http = require 'http'
WebSocketServer = require('websocket').server
_ws = null

class WS
  constructor: (@conf)->
    @server = http.createServer (request, response)->
      console.log('Received request for ' + request.url)
      response.writeHead(404)
      response.end()

    @server.listen 8080, ->
      console.log('WS Server is listening on port 8080')

    @connections = []

    @wsServer = new WebSocketServer
      httpServer: @server
      autoAcceptConnections: yes

    @wsServer.on 'request', (req)->
      console.log req
      connection = req.accept('echo-protocol', req.origin);
      @connections.push connection
      console.log connection

  send: (message)->
    @connections.forEach (connection)->
      connection.sendUTF message

module.exports =
  getSocket: (conf)->
    _ws or (_ws = new WS conf)