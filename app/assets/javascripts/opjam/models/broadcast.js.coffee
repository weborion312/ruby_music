class Opjam.Models.Broadcast extends Backbone.Model
  url: ->
    if @id
      "/api/v1/broadcasts/#{@id}"
    else
      "/api/v1/broadcasts"

  defaults:
    klass: 'Broadcast'
