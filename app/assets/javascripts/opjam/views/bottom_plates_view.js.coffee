class Opjam.Views.BottomPlatesView extends Backbone.View

  el: '#bottom-plates'
  template: JST['bottom_plates/index']

  events:
    'click nav.plates td.home a'       : 'homeFilter'
    'click nav.plates td.profiles a'   : 'profilesFilter'
    'click nav.plates td.tracks a'     : 'tracksFilter'
    'click nav.plates td.broadcasts a' : 'broadcastsFilter'
    'click nav.plates td.radios a'     : 'radiosFilter'
    'click nav.plates td.charts a'     : 'chartsFilter'

  render: ->
    $(@el).html @template()
    @

  homeFilter: ->
    Opjam.wall.display 'all'

  profilesFilter: ->
    Opjam.wall.display 'profiles'

  tracksFilter: ->
    Opjam.wall.display 'tracks'

  broadcastsFilter: ->
    Opjam.wall.display 'broadcasts'

  radiosFilter: ->
    Opjam.popup.fetch 'not_implemented'

  chartsFilter: ->
    Opjam.popup.fetch 'not_implemented'
