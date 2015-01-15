
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
