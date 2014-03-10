class Opjam.Collections.Plates extends Backbone.Collection

  all: ->
    rows = 4
    columns = 48
    num_plates = rows * columns
    num_users = Math.ceil(0.3 * num_plates)
    num_tracks = Math.ceil(0.6 * num_plates)
    num_broadcasts = Math.ceil(0.1 * num_plates)
    @.profiles(num_users).concat(@.tracks(num_tracks)).concat(@.broadcasts(num_broadcasts))

  profiles: (length = 160) ->
    users = []
    unless Opjam.users.models.length == 0
      while users.length < length
        users.push(user) for user in Opjam.users.models
    users

  tracks: (length = 160) ->
    tracks = []
    unless Opjam.tracks.models.length == 0
      while tracks.length < length
        tracks.push(track) for track in Opjam.tracks.models
    tracks

  broadcasts: (length = 160) ->
    broadcasts = []
    unless Opjam.broadcasts.models.length == 0
      while broadcasts.length < length
        broadcasts.push(broadcast) for broadcast in Opjam.broadcasts.models
    broadcasts

  radios: ->
  charts: ->
