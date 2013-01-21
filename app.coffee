###
 * app
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:15
###

require 'iced-coffee-script'

http = require 'http'
express = require 'express'
mongoose = require 'mongoose'

models = require './models'
routes = require './routes'

Config = require './conf'
conf = new Config()

grid = module.exports = {}
app = module.exports.app = express()

cors = (req, res, next)->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  next()


# HTTP Server setup
app.configure ->
  app.set 'port', process.env.PORT or 3000

  app.set 'view engine', 'jade'
  app.set 'views', "#{__dirname}/views"

  # Logging
  app.use express.logger 'dev'

  app.use express.cookieParser()

  # Post data support
  app.use express.bodyParser()
  app.use express.methodOverride()

  # Static files serving
  app.use express.static path.join __dirname, 'public'

  # Session support
  app.use express.session secret: 'Is it secure?'

  app.use cors

  app.get '*', (req, res)-> res.status 404; res.render '404'

# Initialization
adname.init = ->
  #mongoose.set 'debug', yes
  mongoose.connect conf.mongo, {}, (err, db)->
    unless err
      console.log "DB connection initialized."
    else
      throw "Cannot connect to DB (#{err})."
  http.createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get 'port'}"

