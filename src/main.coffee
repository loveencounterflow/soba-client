


### TAINT stopgap solution ###
HOLLERITH = {}

#-----------------------------------------------------------------------------------------------------------
HOLLERITH.$split_os_key = ( keep_key = no ) ->
  ### TAINT code duplication ###
  ### TAINT use library method ###
  return $ ( key, send ) =>
    [ phrase_type
      object
      subject
      idxs    ] = key.split '|'
    [ ok, ov  ] =  object.split ':'
    [ sk, sv  ] = subject.split ':'
    idxs  = idxs.split ','
    idxs  = ( parseInt idx, 10 for idx in idxs )
    send if keep_key then [ key, sk, sv, ok, ov, idxs, ] else [ sk, sv, ok, ov, idxs, ]




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
### https://github.com/AndreasMadsen/clarify, .../trace ###
require 'clarify'
require 'trace'
Error.stackTraceLimit = Infinity
#...........................................................................................................
TEXT                      = require 'coffeenode-text'
#...........................................................................................................
### https://github.com/loveencounterflow/pipedreams2 ###
D2                        = require 'pipedreams2'
$                         = D2.remit.bind D2
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



`
var fs = require('fs');

// There is no limit for the size of the stack trace (v8 default is 10)

setTimeout(function () {
  fs.readFile(__filename, function () {
    process.nextTick(function () {
      throw new Error("custom error");
    });
  });
}, 200);
`








#-----------------------------------------------------------------------------------------------------------
socket.on 'connect', ( P... ) ->
  help "SoBa ソバ Client running on Node v#{process.versions[ 'node' ]}"
  ### TAINT get address from connection / options ###
  help "SoBa ソバ Client connected to http://0.0.0.0:3000/"
  socket.emit 'helo'
  #.........................................................................................................
  # SOBAC.show_entries_for_glyphs socket
  SOBAC.show_entries_for_prefixes socket

#-----------------------------------------------------------------------------------------------------------
@show_entries_for_prefixes = ( socket ) ->
  count     = 0
  prefixes  = [
    # 'os|guide/kwic/sortcode:0815'
    'os|guide/kwic/sortcode:0713'
    ]
  influence   = D2.create_throughstream()
  effluence   = D2.create_throughstream()
  influence.on 'end',    -> whisper "inf. end"
  influence.on 'close',  -> whisper "inf. close"
  influence.on 'finish', -> whisper "inf. finish"
  effluence.on 'end',    -> whisper "eff. end"
  effluence.on 'close',  -> whisper "eff. close"
  effluence.on 'finish', -> whisper "eff. finish"
  # dmz         = D2.ES.pause()
  # dmz1        = D2.ES.pause()
  #.........................................................................................................
  influence
    .pipe $ ( prefix, send ) => send [ 'dump', { take: 10, prefix: prefix, }, ]
    .pipe SOBAC.$emit_groups socket #, { echo: yes, }
    .pipe $ ( event, send ) => send key = event[ 2 ][ 'key' ] if event?
    .pipe HOLLERITH.$split_os_key()
    .pipe $ ( [ sk, sv, ok, ov, idxs, ], send, end ) =>
      glyph   = sv
      kwic_sc = ov
      setImmediate -> effluence.write [ glyph, kwic_sc, ] # 'glyph with KWIC sortcode'
      # effluence.write [ glyph, kwic_sc, ] # 'glyph with KWIC sortcode'
      if end?
        setImmediate -> effluence.end()
        setImmediate -> end()
  #.........................................................................................................
  effluence
    .pipe D2.$show()
    .pipe $ ( [ glyph, kwic_sc, ], send ) =>
      send [ 'dump', { take: 2, prefix: "so|glyph:#{glyph}|rank", rsvp: { glyph, kwic_sc, } }, ]
    .pipe $ ( data, send, end ) =>
      send data
      # debug '©kN33r', effluence.readable, effluence.writable
      # CND.dir effluence
      if end?
        setImmediate ->
          urge "ended"
          end()
    .pipe SOBAC.$emit_groups socket  #, { echo: yes, }
    .pipe $ ( data, send ) => help data if data?; send data
  #.........................................................................................................
  for prefix in prefixes
    influence.write prefix
  influence.end()

# #-----------------------------------------------------------------------------------------------------------
# @show_entries_for_prefixes = ( socket ) ->
#   count     = 0
#   prefixes  = [
#     # 'os|guide/kwic/sortcode:0815'
#     'os|guide/kwic/sortcode:0713'
#     ]
#   confluence  = D2.create_throughstream()
#   #.........................................................................................................
#   confluence
#     #.......................................................................................................
#     .pipe $ ( prefix, send ) =>
#       send [ 'dump', { take: 250, prefix: prefix, }, ]
#     #.......................................................................................................
#     .pipe SOBAC.$emit_groups socket #, { echo: yes, }
#     #.......................................................................................................
#     .pipe $ ( event, send, end ) =>
#       count += 1
#       #.....................................................................................................
#       if event?
#         count_txt = TEXT.flush_right count, 3, ' '
#         [ type, ..., ] = event
#         key   = event[ 2 ][ 'key' ]
#         front = key[ 0 ... 72 ]
#         rear  = key[ key.length - 16 ... ]
#         info "(#{count_txt}) #{front} ... #{rear}"
#       #.....................................................................................................
#       send event
#       #.....................................................................................................
#       if end?
#         warn "stream ended"
#         end()
#   #.........................................................................................................
#   for prefix in prefixes
#     confluence.write prefix
#   confluence.end()

#-----------------------------------------------------------------------------------------------------------
@show_entries_for_glyphs = ( socket ) ->
  CHR         = require 'coffeenode-chr'
  # glyphs      = CHR.chrs_from_text '一二三'#〇四五六七八九十百千萬'
  count       = 0
  glyphs      = CHR.chrs_from_text '片版八兌附楚國'#〇四五六七八九十百千萬'
  # glyphs      = ( CHR.as_uchr cid for cid in [ 0x4e00 .. 0x4fff ] )
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
    # .pipe $ ( glyph, send ) =>
    #   CND.dir send[ '%self' ]
    .pipe $ ( glyph, send ) =>
      # send [ 'dump', { take: 30, prefix: "so|glyph:#{glyph}|guide/sortcode",      'glyph': glyph, }, ]
      send [ 'dump', { take: 30, prefix: "so|glyph:#{glyph}|guide/kwic/sortcode", 'glyph': glyph, }, ]
      # send [ 'dump', { take: 30, prefix: "so|glyph:#{glyph}|reading/py", 'glyph': glyph, }, ]
      # send [ 'dump', { take: 200, prefix: "so|glyph:#{glyph}|", 'glyph': glyph, }, ]
    .pipe SOBAC.$emit_groups socket, { echo: yes, }
    # .pipe SOBAC.$emit socket
    .pipe $ ( event, send, end ) =>
      count += 1
      #.....................................................................................................
      if event?
        count_txt = TEXT.flush_right count, 3, ' '
        [ type, ..., ] = event
        if type is 'batch' then info "(#{count_txt}) #{event[ 1 ]} #{event[ 2 ][ 'key' ]}"
        else                    urge event[ 1 ][ 'glyph' ]
      #.....................................................................................................
      else
        null
        # warn '---'
      #.....................................................................................................
      send event
      #.....................................................................................................
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
# ### TAINT `me` simplifyingly set to `socket` ###
# @$details_from_glyph = ( me, type ) ->
#   return $ ( glyph, send ) =>
#     send.pause()
#     id            = @_new_id()
#     type_with_id  = "#{type}##{id}"
#     me.on type_with_id, ( event ) =>
#       send event
#       unless event?
#         send.resume()
#         me.removeAllListeners type_with_id
#     me.emit type_with_id, { take: 3, prefix: "so|glyph:#{glyph}|", }

#-----------------------------------------------------------------------------------------------------------
### TAINT `me` simplifyingly set to `socket` ###
@$emit_groups = ( me, settings ) ->
  ### In a stream of incoming 'trigger' events of the form `[ type, payload..., ]`, the `$emit_groups` transform
  will emit events one by one to the far side using the WebSocket connection represented by `me`; it will
  pause the stream between events until the far side has signalled completion for the present event by
  sending a `null` event. Thus, a simple synchronization between client and server is achieved. Furthermore,
  randomly individualized events of the form `[ "#{type}##{id}", ... ]` are actually used in order to
  prevent the handler from inadvertently catching spurious events originating from concurrent code. All
  event listeners are cleared on completion. Downstream transforms will see multiple `null` events, one for
  each of all the incoming trigger events.

  Example (with a database of CJK characters and a backend that supports a `dump` event):

  ```coffee
  glyphs      = CHR.chrs_from_text '一二三'
  count       = 0
  confluence  = D2.create_throughstream()
  confluence
    .pipe $ ( glyph, send ) =>
      send [ 'dump', { prefix: "so|glyph:#{glyph}|reading/py", }, ]
    .pipe SOBAC.$emit_groups socket
    .pipe $ ( event, send, end ) =>
      count += 1
      if event? then  info "-<#{count}>-", "#{event[ 1 ]} #{event[ 2 ][ 'key' ]}"
      else            warn '---'
      send event
      if end?
        warn "stream ended"
        end()
  for glyph in glyphs
    confluence.write glyph
  confluence.end()
  ```

  This will produce:

  ```
  -<1>- 0 so|glyph:一|reading/py/base:yi|0
  -<2>- 1 so|glyph:一|reading/py:yī|0
  ---
  -<4>- 0 so|glyph:二|reading/py/base:er|0
  -<5>- 1 so|glyph:二|reading/py:èr|0
  ---
  -<7>- 0 so|glyph:三|reading/py/base:san|0
  -<8>- 1 so|glyph:三|reading/py:sān|0
  ---
  ´´´

  We practically have 'expanded' the stream from glyphs to LevelDB keys containing further information. Of
  course, depending on data available, each block may contain any number of response events. By contrast,
  what you will get using the non-grouping `$emit` transform instead is this:

  ´´´
  -<1>- 0 so|glyph:一|reading/py/base:yi|0
  -<2>- 0 so|glyph:二|reading/py/base:er|0
  -<3>- 0 so|glyph:三|reading/py/base:san|0
  -<4>- 1 so|glyph:一|reading/py:yī|0
  -<5>- 1 so|glyph:二|reading/py:èr|0
  -<6>- 1 so|glyph:三|reading/py:sān|0
  ´´´
  ###
  #.........................................................................................................
  echo = settings?[ 'echo' ] ? no
  #.........................................................................................................
  return $ ( trigger_event, send ) =>
    send.pause()
    [ type
      payload...  ] = trigger_event
    id              = @_new_id()
    type_with_id    = "#{type}##{id}"
    #.......................................................................................................
    do ( type_with_id ) =>
      is_first = yes
      #.....................................................................................................
      me.on type_with_id, ( event ) =>
        if echo and is_first
          is_first = no
          send trigger_event
        send event
        unless event?
          # send.read()
          send.resume()
          me.removeAllListeners type_with_id
      #.....................................................................................................
      me.emit type_with_id, payload...

#-----------------------------------------------------------------------------------------------------------
### TAINT `me` simplifyingly set to `socket` ###
@$emit = ( me ) ->
  last_twi  = null
  #.........................................................................................................
  return $ ( event, send, end ) =>
    if event?
      [ type
        payload...  ] = event
      id              = @_new_id()
      type_with_id    = "#{type}##{id}"
      #.....................................................................................................
      do ( type_with_id ) =>
        last_twi = type_with_id if end?
        me.on type_with_id, ( event ) =>
          if event?
            send event
          unless event?
            me.removeAllListeners type_with_id
            end() if last_twi is type_with_id
        #...................................................................................................
        me.emit type_with_id, payload...
    #.......................................................................................................
    end() if end? and not event?

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




