


###
#===========================================================================================================



 .d8888b.   .d88888b.  888888b.          d8888     .d8888b.  888      8888888 8888888888 888b    888 88888888888
d88P  Y88b d88P" "Y88b 888  "88b        d88888    d88P  Y88b 888        888   888        8888b   888     888
Y88b.      888     888 888  .88P       d88P888    888    888 888        888   888        88888b  888     888
 "Y888b.   888     888 8888888K.      d88P 888    888        888        888   8888888    888Y88b 888     888
    "Y88b. 888     888 888  "Y88b    d88P  888    888        888        888   888        888 Y88b888     888
      "888 888     888 888    888   d88P   888    888    888 888        888   888        888  Y88888     888
Y88b  d88P Y88b. .d88P 888   d88P  d8888888888    Y88b  d88P 888        888   888        888   Y8888     888
 "Y8888P"   "Y88888P"  8888888P"  d88P     888     "Y8888P"  88888888 8888888 8888888888 888    Y888     888



#===========================================================================================================
###



############################################################################################################
njs_path                  = require 'path'
#...........................................................................................................
TRM                       = require 'coffeenode-trm'
rpr                       = TRM.rpr.bind TRM
badge                     = 'ソバ/SERVER'
info                      = TRM.get_logger 'info',    badge
alert                     = TRM.get_logger 'alert',   badge
debug                     = TRM.get_logger 'debug',   badge
warn                      = TRM.get_logger 'warn',    badge
urge                      = TRM.get_logger 'urge',    badge
whisper                   = TRM.get_logger 'whisper', badge
help                      = TRM.get_logger 'help',    badge
#...........................................................................................................
# TEMPLATES                 = require './TEMPLATES'
#...........................................................................................................
# new_app                   = require 'express'
# njs_http                  = require 'http'
# new_sio_server            = require 'socket.io'
# new_router                = require 'socket.io-events'
new_sio_client            = require 'socket.io-client'


sio_client = new_sio_client 'http://0.0.0.0:3000/'

### NB difference to server side:
  * no `connection` event, but `connect`
  * no `socket` argument; use `sio_client` to listen for events. ###
sio_client.on 'connect',           -> help "client: connect"
sio_client.on 'connect_error',     -> help "client: connect_error"
sio_client.on 'connect_timeout',   -> help "client: connect_timeout"
sio_client.on 'reconnect',         -> help "client: reconnect"
sio_client.on 'reconnect_attempt', -> help "client: reconnect_attempt"
sio_client.on 'reconnect_error',   -> help "client: reconnect_error"
sio_client.on 'reconnect_failed',  -> help "client: reconnect_failed"
sio_client.on 'reconnecting',      -> help "client: reconnecting"

#-----------------------------------------------------------------------------------------------------------
sio_client.on 'news', ( message... ) ->
  info 'news:', message

sio_client.on 'connect', ( P... ) ->
  # SIO_GRAPEVINE = sio_client.connect '/grapevine'
  # debug '©D8htg', SIO_GRAPEVINE.nsp
  # SIO_GRAPEVINE.on 'news', ( message ) ->
  #   info '/grapevine/news:', message
  #.........................................................................................................
  # after 2, ->
  # debug '©YVHz3', sio_client.nsp
  # sio_client.emit 'gimme-json'
  sio_client.emit 'helo'

sio_client.on 'helo', ( data ) =>
  help 'updated-client-id', data[ 'client-id' ]


