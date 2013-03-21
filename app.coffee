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
#spdy = require 'spdy'
express = require 'express'
i18n = require 'i18n'

mongoose = require 'mongoose'
passport = require 'passport'
BasicStrategy = require('passport-http').BasicStrategy

moment = require 'moment'

models = require './models'
routes = require './routes'

Config = require './conf'
conf = new Config()

ECT = require 'ect'
ectRenderer = ECT watch: true, root: __dirname + '/views'

grid = module.exports = {}
app = module.exports.app = express()

passport.use new BasicStrategy (username, password, done)->
  models.User.findOne {username: username}, (err, user)->
    return done err if err
    return done null, false if not user
    return done null, false if not user.validPassword password
    return done null, user

cors = (req, res, next)->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  next()

random = ->
  func = arguments[Math.floor(Math.random() * arguments.length)]
  func.call() if typeof(func) is 'function'

processRandom = (req, res, next)->
  unless req.method is 'GET'
    fail = -> res.send 500
    forbidden = -> res.send 401
    random next, fail, forbidden
  else
    next()

i18n.configure
  locales:['ru', 'en', 'de']
  defaultLocale: 'en'
  cookie: 'lang'


# HTTP Server setup
app.configure ->
  app.set 'port', process.env.PORT or 3000

#  app.set 'view engine', 'jade'
  app.set 'views', "#{__dirname}/views"

  app.engine '.ect', ectRenderer.render

  app.use passport.initialize()

  app.use express.compress()

  # Static files serving
  oneYear = 31557600000
  app.use express.static path.join(__dirname, 'public'), {maxAge: oneYear}

  # Logging
  app.use express.logger 'dev'

  app.use express.cookieParser()

  app.use i18n.init

  app.use (req, res, next)->
    res.locals.language = req.language
    moment.lang req.language
    res.locals.__ = res.__ = ->
      i18n.__.apply req, arguments
    res.locals.__n = res.__n = ->
      i18n.__n.apply req, arguments
    next()

  # Post data support
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use express.favicon()

  # Session support
  app.use express.session secret: 'Is it secure?'

  app.use cors

#  app.use processRandom

app.locals
  node_env: process.env.NODE_ENV
#  staticDomain: '//static.tournament.local:3000'
  staticDomain: '//tournament.local:3000'
  moment: moment
  __: -> i18n.__ arguments
  languages: ['ru', 'en', 'de']


app.get '/api/championships', routes.api.championships.list

app.get '/api/countries', routes.api.countries.list
app.get '/api/countries/:_id', routes.api.countries.item

app.get '/api/games', routes.api.games.list
app.get '/api/games/:_id', routes.api.games.item
app.post '/api/games', routes.api.games.create

app.get '/api/matches', routes.api.matches.list
app.post '/api/matches', routes.api.matches.create
app.put '/api/matches', routes.api.matches.update

app.get '/api/players', routes.api.players.list
app.post '/api/players', routes.api.players.create

app.get '/api/reports', routes.api.reports.list
app.get '/api/reports/:_id', routes.api.reports.item

app.get '/api/results', routes.api.results.list
app.get '/api/results/:_id', routes.api.results.item

app.get '/api/rounds', routes.api.rounds.list
app.get '/api/rounds/:_id', routes.api.rounds.item
app.post '/api/rounds', routes.api.rounds.create

app.get '/api/stages', routes.api.stages.list
app.get '/api/stages/:_id', routes.api.stages.item
app.post '/api/stages', routes.api.stages.create

app.get '/api/teams', routes.api.teams.list
app.post '/api/teams', routes.api.teams.create
app.get '/api/teams/:_id', routes.api.teams.item
app.delete '/api/teams/bulk', routes.api.teams.delete


app.get '/', passport.authenticate('basic', { session: false }), (req, res)->
  res.header('cache-control', 'public, max-age=2592000')
  res.render 'index.ect'

app.get '/reports', routes.reports.list
app.get '/reports/:_id', routes.reports.item

app.get '*', (req, res)-> res.status 404; res.render '404'

# Initialization
grid.init = ->
  #mongoose.set 'debug', yes
  mongoose.connect conf.mongo, {}, (err, db)->
    unless err
      console.log "DB connection initialized."
    else
      throw "Cannot connect to DB (#{err})."
#  spdy.createServer({}, app).listen app.get('port'), ->
#    console.log "Express server listening on port #{app.get 'port'}"
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

# Добавить нотификацию, если была выбрана команда не из списка