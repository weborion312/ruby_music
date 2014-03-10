class Opjam.Models.Track extends Backbone.Model
  url: ->
    if @id
      "/api/v1/tracks/#{@id}"
    else
      "/api/v1/tracks"

  defaults:
    klass: 'Track'
