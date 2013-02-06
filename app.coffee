###
 * app
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:15
###

require 'iced-coffee-script'

path = require 'path'
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


app.get '/api/championships', routes.api.championships.list

app.get '/api/countries', routes.api.countries.list
app.get '/api/countries/:_id', routes.api.countries.item

app.get '/api/games', routes.api.games.list
app.get '/api/games/:_id', routes.api.games.item

app.get '/api/matches', routes.api.matches.list

app.get '/api/players', routes.api.players.list

app.get '/api/reports', routes.api.reports.list
app.get '/api/reports/:_id', routes.api.reports.item

app.get '/api/results', routes.api.results.list
app.get '/api/results/:_id', routes.api.results.item

app.get '/api/rounds', routes.api.rounds.list
app.get '/api/rounds/:_id', routes.api.rounds.item

app.get '/api/stages', routes.api.stages.list
app.get '/api/stages/:_id', routes.api.stages.item

app.get '/api/teams', routes.api.teams.list
app.get '/api/teams/:_id', routes.api.teams.item

app.get '*', (req, res)-> res.status 404; res.render '404'

# Initialization
grid.init = ->
  #mongoose.set 'debug', yes
  mongoose.connect conf.mongo, {}, (err, db)->
    unless err
      console.log "DB connection initialized."
    else
      throw "Cannot connect to DB (#{err})."
  http.createServer(app).listen app.get('port'), ->
    console.log "Express server listening on port #{app.get 'port'}"


# 1/32, 1/16 могут быть таблицей
# Инфо 1 2 3

# Сортировка

# Игры
# Выйграно
# Ничья
# Проиграно
# Очки (редактируются)
# Разница (редактируются)

# Возможен фиктивный матч