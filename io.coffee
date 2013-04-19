###
 * io
 * @author: actuosus
 * Date: 17/04/2013
 * Time: 23:10
###

http = require 'http'
io = require('socket.io')
socket = null

class IO
  constructor: (@conf)->
    @server = io.listen 8080

  send: (message)->
    @server.sockets.emit 'message', message

module.exports =
  getSocket: (conf)->
    socket or (socket = new IO conf)