class Opjam.Models.User extends Backbone.Model

  url: ->
    if @id
      "/api/v1/users/#{@id}"
    else
      "/api/v1/users"

  defaults:
    klass: 'User'
