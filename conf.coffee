###
 * conf
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 03:00
###

module.exports = ->
  switch process.env.NODE_ENV
    when 'production'
      _redis = null
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
      mongo: process.env.MONGOLAB_URI
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
#      hostname: 'tournament.local'
      hostname: '0.0.0.0'
      port: 3001,
      mongo: 'mongodb://localhost/tournament_grid_test'
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
      hostname: 'tournament.local'
      port: 3000,
      mongo: 'mongodb://localhost/tournament_grid'
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
