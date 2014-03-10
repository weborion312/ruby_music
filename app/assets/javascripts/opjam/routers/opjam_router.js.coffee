class Opjam.Routers.OpjamRouter extends Backbone.Router
  routes: {
    ''                : 'home'
    '!/*path'         : 'show'
    '!profiles/:user' : 'profiles'
    '!tracks/:token'  : 'tracks'
    '!broadcasts/:id'  : 'broadcasts'
  }

  initialize: ->
    Opjam.popup              = new Opjam.Models.Popup
    Opjam.player             = new Opjam.Models.Player
    Opjam.wall               = new Opjam.Models.Wall
    Opjam.currentUser        = new Opjam.Models.Session
    Opjam.tracks             = new Opjam.Collections.Tracks
    Opjam.users              = new Opjam.Collections.Users
    Opjam.broadcasts         = new Opjam.Collections.Broadcasts
    Opjam.plates             = new Opjam.Collections.Plates
    Opjam.bottomPlatesView   = new Opjam.Views.BottomPlatesView

    Opjam.wall.display 'all'

    new Opjam.Views.PopupView model: Opjam.popup

    Opjam.playerView = new Opjam.Views.PlayerView
      model: Opjam.player
      collection: Opjam.tracks

  show: (path) ->
    return if path.length == 0
    Opjam.popup.fetch path

  profiles: (user) ->
    Opjam.popup.fetch 'profiles/' + user

  tracks: (token) ->
    Opjam.popup.fetch 'tracks/' + token

  broadcasts: (id) ->
    Opjam.popup.fetch 'broadcasts/' + id

  home: ->
    $('footer').append(Opjam.playerView.render().el)
