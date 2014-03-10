class Opjam.Views.TrackRingView extends Backbone.View

  template: JST['track_ring/index']
  tagName: 'li'
  className: 'track poster'

  events:
    "click ul.ring li.track a.play"  : "wallRingPlayerPlay"
    "click ul.ring li.track a.pause" : "wallRingPlayerPause"

  initialize: ->
    @model.on('reset', @render, @)

  render: ->
    $(@el).attr('data-type', 'track')
    $(@el).attr('id', 'track_'+@model.get('id'))
    $(@el).attr('data-id', @model.get('slug'))

    $(@el).html(@template(track: @model.toJSON()))
    @

  wallRingPlayerPlay: (event) ->
    event.preventDefault()
    track_id = event.currentTarget.attributes[2].value
    Opjam.playerView.pushToPlay track_id

  wallRingPlayerPause: (event) ->
    event.preventDefault()
    Opjam.playerView.pause()
