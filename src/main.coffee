


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
njs_fs                    = require 'fs'
#...........................................................................................................
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'ソバ/CLIENT'
info                      = CND.get_logger 'info',    badge
alert                     = CND.get_logger 'alert',   badge
debug                     = CND.get_logger 'debug',   badge
warn                      = CND.get_logger 'warn',    badge
urge                      = CND.get_logger 'urge',    badge
whisper                   = CND.get_logger 'whisper', badge
help                      = CND.get_logger 'help',    badge
#...........................................................................................................
TEXT                      = require 'coffeenode-text'
#...........................................................................................................
### https://github.com/loveencounterflow/pipedreams ###
D                         = require 'pipedreams'
D2                        = require 'pipedreams2'
$                         = D2.remit.bind D
#...........................................................................................................
random_integer            = CND.get_rnd_int 592, 762
#...........................................................................................................
new_socket                = require 'socket.io-client'
socket                    = new_socket 'http://0.0.0.0:3000/'
# #...........................................................................................................
# ### https://github.com/turbonetix/socket.io-events ###
# new_router                = require 'socket.io-events'

### **NB** difference to server side:
  * no `connection` event, but `connect`
  * no `socket` argument; use `socket` to listen for events. ###
socket.on 'connect',           -> help "client: connect"
socket.on 'connect_error',     -> help "client: connect_error"
socket.on 'connect_timeout',   -> help "client: connect_timeout"
socket.on 'reconnect',         -> help "client: reconnect"
socket.on 'reconnect_attempt', -> help "client: reconnect_attempt"
socket.on 'reconnect_error',   -> help "client: reconnect_error"
socket.on 'reconnect_failed',  -> help "client: reconnect_failed"
socket.on 'reconnecting',      -> help "client: reconnecting"

original_onevent = socket.onevent.bind socket
socket.onevent = ( Q ) ->
  [ type, data, ] = Q[ 'data' ]
  # warn '©HRjXh', type, JSON.stringify data
  original_onevent Q

# socket.on 'dump#672126', ( P... ) ->
#   urge '©4djLo', P

#-----------------------------------------------------------------------------------------------------------
socket.on 'connect', ( P... ) ->
  help "SoBa ソバ Client running on Node v#{process.versions[ 'node' ]}"
  ### TAINT get address from connection / options ###
  help "SoBa ソバ Client connected to http://0.0.0.0:3000/"
  socket.emit 'helo'
  count       = 3
  skip        = 0
  limit       = skip + count
  # prefix      = 'os|reading/py'
  # prefix      = 'os|strokeorder/short:333|'
  # SOBAC.show_glyph_pods socket, null, ( P... ) -> debug '©81poA', P
  CHR         = require 'coffeenode-chr'
  glyphs      = CHR.chrs_from_text '〇一二三四五六七八九十百千萬'#'
  # #---------------------------------------------------------------------------------------------------------
  # for glyph in glyphs
  #   prefix      = "so|glyph:#{glyph}"
  #   urge "prefix: #{rpr prefix}"
  #   stream      = SOBAC.dump_ng socket, { take: limit, skip: skip, prefix: prefix, }
  #   stream.pipe D2.$show()
  #---------------------------------------------------------------------------------------------------------
  count = 0
  confluence  = D2.create_throughstream()
  confluence
    .pipe SOBAC.$details_from_glyph socket, 'dump'
    .pipe $ ( event, send, end ) =>
      count += 1
      if event? then  info "-<#{count}>-", "#{event[ 1 ]} #{event[ 2 ][ 'key' ]}"
      else            warn '---'
      send event
      if end?
        warn "stream ended"
        end()
  #.........................................................................................................
  for glyph in glyphs
    confluence.write glyph
  confluence.end()

  # output        = D2.create_throughstream()
  # output
  #   .pipe $ ( data, send ) ->
  #     # CND.dir send
  #     debug '©YZEYm', data
  # for idx in [ 10 .. 30 ]
  #   output.write idx
  # output.end()

  # socket.emit 'dump#672126', { skip: 0, take: 3, prefix: 'so|glyph:〇|' }
  # socket.on 'dump#672126', ( P ) ->
  #   debug '©ORUuU', P

  # prefix      = 'so|glyph:彡|'
  # urge "prefix: #{rpr prefix}"
  # stream      = SOBAC.dump_ng socket, { take: limit, skip: skip, prefix: prefix, }
  # stream.pipe D2.$show()

#-----------------------------------------------------------------------------------------------------------
socket.on 'helo', ( data ) =>
  help 'updated-client-id', data[ 'client-id' ]

#-----------------------------------------------------------------------------------------------------------
@_new_id = -> random_integer 1e5, 1e6

#-----------------------------------------------------------------------------------------------------------
### TAINT `me` simplifyingly set to `socket` ###
@$details_from_glyph = ( me, type ) ->
  return $ ( glyph, send ) =>
    send.pause()
    id            = @_new_id()
    type_with_id  = "#{type}##{id}"
    me.on type_with_id, ( event ) =>
      send event
      send.resume() unless event?
    me.emit type_with_id, { take: 3, prefix: "so|glyph:#{glyph}|", }

#-----------------------------------------------------------------------------------------------------------
### TAINT `me` simplifyingly set to `socket` ###
@$xxxxxxxxxxxxxx = ( me ) ->
  return $ ( event, send ) =>
    send.pause()
    [ type
      payload...  ] = event
    id              = @_new_id()
    type_with_id    = "#{type}##{id}"
    me.on type_with_id, ( event ) =>
      send event
      send.resume() unless event?
    me.emit type_with_id, payload...

#-----------------------------------------------------------------------------------------------------------
@dump_ng = ( me, settings ) ->
  @emit_as_sorted_stream me, 'dump', settings

#-----------------------------------------------------------------------------------------------------------
@emit_as_stream         = ( me, type, data ) -> @_emit_as_stream me, type, data, no
@emit_as_sorted_stream  = ( me, type, data ) -> @_emit_as_stream me, type, data, yes

#-----------------------------------------------------------------------------------------------------------
@_emit_as_stream = ( me, type, data, sorted ) ->
  ### TAINT `me` simplifyingly set to `socket` ###
  id            = @_new_id()
  type_with_id  = "#{type}##{id}"
  ### TAINT couldn't get this to work without using two throughstreams ###
  R             = D2.create_throughstream()
  output        = D2.create_throughstream()
  #.........................................................................................................
  $unwrap = $ ( event, send ) =>
    [ type, tail... ] = event
    if event[ 0 ] is 'batch'
      [ _, _, payload..., ] = event
      send if payload.length is 1 then payload[ 0 ] else payload
  #.........................................................................................................
  $deliver = $ ( event, send ) => R.write event
  #.........................................................................................................
  me.on type_with_id, ( event ) ->
    if event?
      output.write event
    else
      # help "#{type_with_id} completed"
      me.removeAllListeners type_with_id
      output.end()
  #.........................................................................................................
  if sorted
    output
      .pipe D2.$densort 1, 0 #, true
      .pipe $unwrap
      .pipe $deliver
  #.........................................................................................................
  else
    output
      .pipe $unwrap
      .pipe $deliver
  #.........................................................................................................
  me.emit type_with_id, data
  return R

# #-----------------------------------------------------------------------------------------------------------
# @show_glyph_pods = ( me, settings, handler ) ->
#   CHR     = require 'coffeenode-chr'
#   glyphs  = CHR.chrs_from_text '〇一二三四五六七八九'
#   input   = D2.create_throughstream()
#   idx     = -1
#   #.........................................................................................................
#   stream_settings       =
#     'encoding':       'utf-8'
#     'decodeStrings':  yes # ???
#     'objectMode':     yes
#   stream        = wrap_as_socket_stream.createStream stream_settings
#   stream_socket = wrap_as_socket_stream socket
#   #.........................................................................................................
#   input
#     .pipe $ ( chr, send ) ->
#       idx  += +1
#       key   = "so|glyph:#{glyph}|pod:$value|"
#       query = eq: key
#       event = [ 'query', 'get', query, ]
#       batch = [ 'batch', idx, event, ]
#       stream_socket.emit 'xxx', stream, batch
#   #.........................................................................................................
#   # stream
#   #   .pipe D2.$show()
#   #.........................................................................................................
#   for glyph in glyphs
#     input.write glyph


############################################################################################################
SOBAC = @




