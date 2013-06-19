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
#redis = require 'redis'
#spdy = require 'spdy'
express = require 'express'
#RedisStore = require('connect-redis')(express)

i18n = require 'i18n'

mongoose = require 'mongoose'
passport = require 'passport'
BasicStrategy = require('passport-http').BasicStrategy

#IO = require './io'

moment = require 'moment'

models = require './models'

#console.log models

routes = require './routes'

Config = require './conf'
conf = new Config()

ECT = require 'ect'
ectRenderer = ECT watch: true, root: __dirname + '/views'

grid = module.exports = models: models
app = module.exports.app = express()

passport.use new BasicStrategy (username, password, done)->
  models.User.findOne {username: username}, (err, user)->
    return done err if err
    return done null, false if not user
    return done null, false if not user.validPassword password
    return done null, user

passport.serializeUser (user, done)-> done null, user.id

passport.deserializeUser (id, done)->
  console.log id
#  done null, user if user
#  done 'No such user', false
  models.User.findById id, (err, user)-> done err, user

cors = (req, res, next)->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
  res.header 'Access-Control-Allow-Headers', 'Content-Type,X-Requested-With'
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

rangedRandom = (min = 0, max = 255)-> Math.floor(Math.random() * (max - min + 1)) + min

waiter = (req, res, next)->
  if req.query?.start and req.query?.end
    setTimeout next, rangedRandom parseInt(req.query.start), parseInt(req.query.end)
  else
    setTimeout next, rangedRandom 500, 3000

languages = ['ru', 'en', 'de', 'it']

i18n.configure
  locales: languages
  defaultLocale: 'en'
  cookie: 'lang'

# HTTP Server setup
app.configure ->
  app.set 'port', process.env.PORT or 3000

#  app.set 'view engine', 'jade'
  app.set 'views', "#{__dirname}/views"

  app.engine '.ect', ectRenderer.render

  # Static files serving
  #  oneYear = 31557600000
  app.use express.static path.join(__dirname, 'public')

  app.use '/test', express.static path.join(__dirname, 'test')

  # Post data support
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()

  # Session support
  console.log 'Redis', conf._redis
#  app.use express.session(
#    secret: 'Is it secure?'
#    store: new RedisStore(
#      host: conf._redis.host
#      port: conf._redis.port
#      pass: conf._redis.password
#      db: conf._redis.db
#    )
#  )
  app.use express.session secret: 'Is it secure?'
  app.use passport.initialize()
  app.use passport.session()

  app.use i18n.init

  app.use (req, res, next)->
    app.locals.user = req.user
    res.locals.language = req.language
    if req.language and req.language in languages
      moment.lang req.language
    res.locals.__ = res.__ = ->
      i18n.__.apply req, arguments
    res.locals.__n = res.__n = ->
      i18n.__n.apply req, arguments
    next()

#  app.use express.favicon()

  app.use cors

app.configure 'development', ->
  mongoose.set 'debug', yes
  # Logging
  app.use express.logger 'dev'
  # Error handling
  app.use express.errorHandler dumpExceptions: yes, showStack: yes

#  app.use (req, res, next)->
#    if req.url.match /api/
#      waiter req, res, next
#    else
#      next()

app.configure 'production', ->
  # Compression
  app.use express.compress()
  # Error handling
  app.use express.errorHandler()
  # Static files serving
  oneYear = 31557600000
  app.use express.static path.join(__dirname, 'public'), {maxAge: oneYear}


#  app.use processRandom
port = 80
port = conf.port if conf.port

if port is 80
  staticDomain = "//#{conf.hostname}"
else
  staticDomain = "//#{conf.hostname}:#{port}"

app.locals
  node_env: process.env.NODE_ENV
#  node_env: 'production'
#  staticDomain: '//static.tournament.local:3000'
#  staticDomain: '//tournament.local:3000'
#  staticDomain: staticDomain
  staticDomain: ''
  moment: moment
  __: -> i18n.__ arguments
  languages: languages

# CORS for all URLs.
app.options '*', (req, res)->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'accept, origin, content-type, referer, cache-control, pragma, user-agent, X-Requested-With'
  res.header 'Access-Control-Max-Age', 1728000
  res.header 'Content-Length', 0
  res.send 204

app.post '/api/logs', routes.api.logs.create

app.get '/api/countries', routes.api.countries.list
app.get '/api/countries/names', routes.api.countries.namesList
app.get '/api/countries/:_id', routes.api.countries.item

app.post '/hidden/countries', routes.hidden.countries.create

app.get '/api/games', routes.api.games.list
app.get '/api/games/:_id', routes.api.games.item
app.put '/api/games/:_id', routes.api.games.update
app.post '/api/games', routes.api.games.create
app.delete '/api/games/:_id', routes.api.games.delete

app.post '/hidden/games', routes.api.games.create

app.get '/api/matches', routes.api.matches.list
app.get '/api/matches/:_id', routes.api.matches.item
app.post '/api/matches', routes.api.matches.create
app.put '/api/matches', routes.api.matches.update
app.put '/api/matches/:_id', routes.api.matches.update
app.delete '/api/matches/:_id', routes.api.matches.delete

app.post '/hidden/matches', routes.api.matches.create
app.delete '/hidden/matches/:_id', routes.api.matches.delete

app.get '/api/players', routes.api.players.list
app.get '/api/players/:_id', routes.api.players.item
app.post '/api/players', routes.api.players.create
app.put '/api/players', routes.api.players.update
app.put '/api/players/:_id', routes.api.players.update

app.post '/hidden/players', routes.api.players.create

# Should not be presented.
#app.delete '/api/players/:_id', routes.api.players.delete

app.get '/api/reports', routes.api.reports.list
app.get '/api/reports/:_id', routes.api.reports.item

app.post '/hidden/reports', routes.hidden.reports.create
app.put '/hidden/reports/:_id', routes.hidden.reports.update
app.delete '/hidden/reports/:_id', routes.hidden.reports.delete

app.get '/api/result_sets', routes.api.resultSets.list
app.get '/api/result_sets/:_id', routes.api.resultSets.item
app.post '/api/result_sets', routes.api.resultSets.create
app.put '/api/result_sets/:_id', routes.api.resultSets.update
app.delete '/api/result_sets/:_id', routes.api.resultSets.delete

app.post '/hidden/result_sets', routes.api.resultSets.create

app.get '/api/results', routes.api.results.list
app.get '/api/results/:_id', routes.api.results.item
app.post '/api/results', routes.api.results.create
app.put '/api/results/:_id', routes.api.results.update
app.delete '/api/results/:_id', routes.api.results.delete

app.get '/api/rounds', routes.api.rounds.list
app.get '/api/rounds/:_id', routes.api.rounds.item
app.post '/api/rounds', routes.api.rounds.create
app.put '/api/rounds/:_id', routes.api.rounds.update
app.delete '/api/rounds/:_id', routes.api.rounds.delete

app.post '/hidden/rounds', routes.api.rounds.create

app.get '/api/brackets', routes.api.brackets.list
app.get '/api/brackets/:_id', routes.api.brackets.item
app.post '/api/brackets', routes.api.brackets.create
app.put '/api/brackets/:_id', routes.api.brackets.update
app.delete '/api/brackets/:_id', routes.api.brackets.delete

app.post '/hidden/brackets', routes.api.brackets.create

app.get '/api/stages', routes.api.stages.list
app.get '/api/stages/:_id', routes.api.stages.item
app.post '/api/stages', routes.api.stages.create
app.put '/api/stages/:_id', routes.api.stages.update
app.delete '/api/stages/:_id', routes.api.stages.delete
app.delete '/api/stages/bulk', routes.api.stages.delete

app.post '/hidden/stages', routes.api.stages.create

app.get '/api/teams', routes.api.teams.list
app.post '/api/teams', routes.api.teams.create
app.get '/api/teams/:_id', routes.api.teams.item
app.put '/api/teams/:_id', routes.api.teams.update
app.delete '/api/teams/:_id', routes.api.teams.delete
app.delete '/api/teams/bulk', routes.api.teams.delete

app.post '/hidden/teams', routes.api.teams.create

app.get '/api/team_refs', routes.api.team_refs.list
app.post '/api/team_refs', routes.api.team_refs.create
app.get '/api/team_refs/:_id', routes.api.team_refs.item
app.put '/api/team_refs/:_id', routes.api.team_refs.update
app.delete '/api/team_refs/:_id', routes.api.team_refs.delete
app.delete '/api/team_refs/bulk', routes.api.team_refs.delete

app.post '/hidden/team_refs', routes.api.team_refs.create

ensureAuthenticated = (req, res, next) ->
#  console.log 'ensureAuthenticated', req.isAuthenticated()
  return next() if req.isAuthenticated()
  res.redirect '/'

app.get '/', passport.authenticate('basic'), (req, res)->
  console.log req.user
#  res.header('cache-control', 'public, max-age=2592000')
  if req.user?.language and not req.cookies?.lang
    res.cookie 'lang', req.user.language
  res.redirect '/reports'
#  res.render 'index.ect'

app.get '/unauthorized', (req, res)->
  res.statusCode = 401
  res.render 'unauthorized.ect'

app.get '/logout', (req, res)->
  req.logout()
  app.locals.user = null
  res.statusCode = 401
  res.render 'logged_out.ect'

app.get '/logs', ensureAuthenticated, routes.logs.list
app.get '/logs/:_id', ensureAuthenticated, routes.logs.item

app.get '/authors', ensureAuthenticated, routes.authors.list
app.get '/authors/:_id', ensureAuthenticated, routes.authors.item

app.get '/reports', ensureAuthenticated, routes.reports.list
app.get '/reports/create', ensureAuthenticated, routes.reports.createForm
app.post '/reports/create', ensureAuthenticated, routes.reports.create
app.get '/reports/:_id', ensureAuthenticated, routes.reports.item

app.get '/matches/:_id', ensureAuthenticated, routes.matches.item
app.get '/games/:_id', ensureAuthenticated, routes.games.item

app.get '/teams/:_id', ensureAuthenticated, routes.teams.item

app.get '/players/:_id', ensureAuthenticated, routes.players.item

app.get '*', (req, res)-> res.status 404; res.render '404.ect'


# Initialization
grid.init = (cb)->
#  spdy.createServer({}, app).listen app.get('port'), ->
#    console.log "Express SPDY server listening on port #{app.get 'port'}"
  grid.server = http.createServer(app)
  conf.server = grid.server
#  socket = IO.getSocket(conf)
#  socket.start server
  grid.server.listen app.get('port'), ->
    console.log "Express HTTP server listening on port #{app.get 'port'}" unless app.settings.env is 'test'
    grid.mongoose = mongoose.connect conf.mongo, {}, (err, db)->
      unless err
        console.log "DB connection initialized." unless app.settings.env is 'test'
      else
        throw "Cannot connect to DB (#{err})."

      # Run callback if provided
      cb() if cb

grid.teardown = (cb)->
  grid.mongoose.disconnect ->
    grid.server.close ->
      cb() if cb