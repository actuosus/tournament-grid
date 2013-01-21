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
      return {
      hostname: 'http://tournament-grid.herokuapps.com/'
      mongo: process.env.MONGOLAB_URI
      memcache:
        host: process.env.MEMCACHIER_SERVERS
        port: 11211,
        username: process.env.MEMCACHIER_USERNAME
        password: process.env.MEMCACHIER_PASSWORD
      redis: process.env.REDISTOGO_URL
      secret: ''
      }
    when 'test'
      return {
      hostname: 'localhost'
      port: 3001,
      mongo: 'mongodb://localhost/tournament_grid_test'
      memcache:
        host: 'localhost'
        port: 11211
      secret: ''
      }
    else
      return {
      hostname: 'http://tournament-grid.local:3000'
      port: 3000,
      mongo: 'mongodb://localhost/tournament_grid'
      memcache:
        host: 'localhost'
        port: 11211
      secret: ''
      }
