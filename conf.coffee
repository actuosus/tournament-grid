###
 * conf
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 03:00
###

module.exports = ->
  _redis =
    host: 'localhost'
    hostname: 'localhost'
    username: ''
    password: ''
    db: 1
  mongo = 'mongodb://localhost/tournament_grid'
  switch process.env.NODE_ENV
    when 'production'
      if process.env.REDISCLOUD_URL
        url = require 'url'
        redisURL = url.parse process.env.REDISCLOUD_URL
        _redis =
          host: redisURL.host
          hostname: redisURL.hostname
          port: redisURL.port
          db: redisURL.auth.split(':')[0]
          password: redisURL.auth.split(':')[1]
      return {
      hostname: 'virtus-pro.herokuapp.com'
      mongo: process.env.MONGOLAB_URI or mongo
      memcache:
        host: process.env.MEMCACHIER_SERVERS
        port: 11211,
        username: process.env.MEMCACHIER_USERNAME
        password: process.env.MEMCACHIER_PASSWORD
      _redis: _redis
      secret: ''
      }
    when 'test'
      return {
#      hostname: 'virtuspro.local'
      hostname: '0.0.0.0'
      port: 3001,
      mongo: 'mongodb://localhost/virtuspro_test'
      memcache:
        host: 'localhost'
        port: 11211
      _redis:
        host: 'localhost'
        hostname: 'localhost'
        username: ''
        password: ''
        db: 1
      secret: ''
      }
    else
      return {
      hostname: 'virtuspro.local'
      port: 3000,
      mongo: 'mongodb://localhost/virtuspro'
      _redis:
        host: 'localhost'
        hostname: 'localhost'
        username: ''
        password: ''
        db: 1
      memcache:
        host: 'localhost'
        port: 11211
      secret: ''
      }
