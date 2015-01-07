


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
TRM                       = require 'coffeenode-trm'
rpr                       = TRM.rpr.bind TRM
badge                     = 'ソバ/CLIENT'
info                      = TRM.get_logger 'info',    badge
alert                     = TRM.get_logger 'alert',   badge
debug                     = TRM.get_logger 'debug',   badge
warn                      = TRM.get_logger 'warn',    badge
urge                      = TRM.get_logger 'urge',    badge
whisper                   = TRM.get_logger 'whisper', badge
help                      = TRM.get_logger 'help',    badge
#...........................................................................................................
TEXT                      = require 'coffeenode-text'
BNP                       = require 'coffeenode-bitsnpieces'
#...........................................................................................................
### https://github.com/loveencounterflow/pipedreams ###
D                         = require 'pipedreams'
D2                        = require 'pipedreams2'
$                         = D.remit.bind D
#...........................................................................................................
### https://github.com/nkzawa/socket.io-stream ###
wrap_as_socket_stream     = require 'socket.io-stream'
#...........................................................................................................
new_socket                = require 'socket.io-client'
socket                    = new_socket 'http://0.0.0.0:3000/'

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

#-----------------------------------------------------------------------------------------------------------
# socket.on 'news', ( message... ) ->
#   whisper 'news:', message

# opts.query.uid

socket.on 'connect', ( P... ) ->
  # SIO_GRAPEVINE = socket.connect '/grapevine'
  # debug '©D8htg', SIO_GRAPEVINE.nsp
  # SIO_GRAPEVINE.on 'news', ( message ) ->
  #   info '/grapevine/news:', message
  #.........................................................................................................
  # after 2, ->
  # debug '©YVHz3', socket.nsp
  # socket.emit 'gimme-json'
  help "SoBa ソバ Client running on Node v#{process.versions[ 'node' ]}"
  ### TAINT get address from connection / options ###
  help "SoBa ソバ Client connected to http://0.0.0.0:3000/"
  socket.emit 'helo'
  socket.emit 'news', 'everyone should know', { foo: 42, }
  # socket.emit 'get', [ 'some/key:', ]
  # socket.emit 'get', { gte: 'some/key:' }
  count       = 20
  skip_count  = 100
  limit       = skip_count + count
  SOBAC.dump socket, { take: limit, skip: skip_count, format: 'one-by-one', prefix: 'os|reading', }, ( P... ) -> debug '©fTwiH', P
  # SOBAC.test_dense_sort()

#-----------------------------------------------------------------------------------------------------------
f = ( socket ) ->
  for idx in [ 0 .. 20 ]
    idx_txt = TEXT.flush_right idx, 3, '0'
    key     = "key-#{idx_txt}"
    value   = "value-##{idx_txt}"
    socket.emit 'put', [ key, value, ]

#-----------------------------------------------------------------------------------------------------------
@dump = ( me, settings, handler ) ->
  stream_settings =
    'encoding':       'utf-8'
    'decodeStrings':  yes # ???
    'objectMode':     yes
  stream    = wrap_as_socket_stream.createStream stream_settings
  settings             ?= {}
  settings[ 'take'    ]?= 10
  settings[ 'format'  ]?= 'one-by-one'
  # skip_count            = 12000
  # first_idx             = skip_count
  ### me[ '%socket' ] ###
  ( wrap_as_socket_stream me ).emit 'dump', stream, settings
  # output    = njs_fs.createWriteStream '/tmp/tailer', encoding: 'utf-8'
  ### TAINT using `split` as an expedient; should use streaming JSON decoder ###
  stream
    .pipe D2.$split()
    # .pipe D2.$skip_first skip_count
    .pipe $ ( line, send ) => send JSON.parse line if line? and line.length > 0
    #.......................................................................................................
    .pipe D2.$collect()
    #.......................................................................................................
    .pipe $ ( events, send ) =>
      BNP.shuffle events, 0.2
      send event for event in events
    # #.......................................................................................................
    # .pipe $ ( event, send ) =>
    #   [ type, tail..., ] = event
    #   if type is 'batch'
    #     [ idx, { key, value }, ] = tail
    #     whisper idx, key
    #   send event
    #.......................................................................................................
    .pipe D2.$dense_sort 1, 0, ( [ event_count, max_buffer_size, ] ) ->
      percentage = (     max_buffer_size / event_count * 100  ).toFixed 2
      efficiency = ( 1 - max_buffer_size / event_count        ).toFixed 2
      info """of #{event_count} elements, up to #{max_buffer_size} (#{percentage}%) had to be buffered;
        efficiency: #{efficiency}"""
    #.......................................................................................................
    .pipe $ ( event, send ) =>
      [ type, tail..., ] = event
      if type is 'batch'
        [ idx, { key, value }, ] = tail
        help idx, key
      send event
    #.......................................................................................................
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    .pipe D.$on_end ( send, end ) =>
      process.exit()

#-----------------------------------------------------------------------------------------------------------
@test_dense_sort = ( me ) ->
  input = D.create_throughstream()
  input
    #.......................................................................................................
    .pipe $ ( event, send ) =>
      [ type, tail..., ] = event
      if type is 'batch'
        [ idx, letter, ] = tail
        whisper idx, letter
      send event
    #.......................................................................................................
    .pipe D2.$dense_sort 1, 0, ( [ event_count, max_buffer_size, ] ) ->
      percentage = (     max_buffer_size / event_count * 100  ).toFixed 2
      efficiency = ( 1 - max_buffer_size / event_count        ).toFixed 2
      info """of #{event_count} elements, up to #{max_buffer_size} (#{percentage}%) had to be buffered;
        efficiency: #{efficiency}"""
    #.......................................................................................................
    .pipe $ ( event, send ) =>
      [ type, tail..., ] = event
      if type is 'batch'
        [ idx, letter, ] = tail
        help idx, letter
      send event
    #.......................................................................................................
    .pipe D.$on_end ( send, end ) =>
      process.exit()
  #.........................................................................................................
  input.write [ 'batch', 0, 'A', ]
  input.write [ 'batch', 2, 'C', ]
  input.write [ 'batch', 4, 'E', ]
  input.write [ 'batch', 5, 'F', ]
  input.write [ 'batch', 1, 'B', ]
  input.write [ 'batch', 3, 'D', ]
  # input.write [ 'batch', 3, 'C', ]
  input.end()

# #-----------------------------------------------------------------------------------------------------------
# ### TAINT should be members of soba client representative ('me') ###
# batch_id  = -1
# batches   = {}

# #-----------------------------------------------------------------------------------------------------------
# @get_next_batch_id = ( me ) ->
#   batch_id += 1
#   return "bid#{batch_id}"

# #-----------------------------------------------------------------------------------------------------------
# @dump = ( me, settings, handler ) ->
#   batch_id  = @get_next_batch_id me
#   debug '©SeFJB', batch_id
#   ### TAINT use HOLLERITH library method ###
#   ### TAINT `type` is only first part; choose other name for string ###
#   ### TAINT why do we transport batch ID in the event type string but other data in `settings`? ###
#   type      = "dump|batch-id:#{batch_id}|"
#   me.emit type, settings, ( P... ) ->
#     debug '©l8KIb', P
#     handler()

socket.on 'helo', ( data ) =>
  help 'updated-client-id', data[ 'client-id' ]

# ### TAINT format of data depends on argument `format` in request settings;
#   this would suggest to better use different event types than a setting so receiver method doesn't have
#   to sort that out ###
# ### TAINT need meta-data:
#   request-id (?)
#   idx (consecutive number)
#   ###
# socket.on 'dump', ( data ) =>
#   help 'dump', data

SOBAC = @

############################################################################################################




