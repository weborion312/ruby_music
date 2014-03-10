class Opjam.Models.Session extends Backbone.Model

  defaults:
    authorized: false
    userName: null
    userId: null

  initialize: ->
    session = @
    $.getJSON "users/session_current_user", (user) ->
      session.setCurrentUser(user)

  isAuthorized: ->
    Boolean(@get("authorized"))

  logout: ->
    @set({authorized: false})

  setCurrentUser: (rawUser) ->
    @set({authorized: true})
    @set({userId: rawUser.id})
    @set({username: rawUser.username})
    @set({tracks: rawUser.tracks})
