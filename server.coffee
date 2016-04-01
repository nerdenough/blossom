path = require 'path'
http = require 'http'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
sass = require 'node-sass-middleware'
logger = require 'morgan'

index = require './routes/index'

# Server setup
app = express()
server = http.createServer(app)

# View engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'pug'

app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()
app.use sass
  src: path.join(__dirname, 'sass')
  dest: path.join(__dirname, 'public/css')
  debug: true
  outputStyle: 'compressed'
  prefix: '/css'

app.use express.static path.join(__dirname, 'public')

# Define routes
app.use '/', index

# Catch 404 errors
# Forwarded to the error handlers
app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err

# Development error handler
# Displays stacktrace to the user
if app.get('env') is 'development'
  app.use (err, req, res, next) ->
    console.log err
    res.status err.status || 500
    res.render 'error',
      message: err.message
      error: err

# Production error handler
# Does not display stacktrace to the user
app.use (err, req, res, next) ->
  res.status err.status || 500
  res.render 'error',
    message: err.message
    error: ''

server.listen process.env.PORT || 3000
module.exports = app
