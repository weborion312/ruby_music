class Opjam.Views.PlayerView extends Backbone.View

  el: '#player-container'
  template: JST['player/index']

  events:
    "click #player .controls .play"  : "play"
    "click #player .controls .pause" : "pause"

  initialize: ->
    @collection.on('reset', @render, @)
    @model.on('reset', @render, @)
    @collection.fetch()

  render: ->
    if @model.currentUserLastTrack()
       track = @model.currentUserLastTrack()
    else if @model.currentTrack()
      track = @model.currentTrack()
    else
      track = @collection.last()

    $(@el).html(@template(track: track))
    @updateTrackInfo(track)
    @$('.pause').hide()
    $('ul.ring li a.pause').hide()
    @model.createMediaElement()
    if Opjam.ME
      @setTrack track?.get('slug')
      @seekBarSlider()
      @volumeBarSlider()
    @

  play: (event) ->
    event.preventDefault() unless event == undefined
    @$('.play').hide()
    @$('.pause').show()
    $("ul.ring li.track a.pause").hide()
    $("ul.ring li.track a.play").css('display', '')
    $("ul.ring li.track[data-type=track][data-id=#{Opjam.ME.trackID}] a.pause").show()
    if @popupTrackId() == Opjam.ME.trackID
      $('#popup a.play').hide()
      $('#popup a.pause').show()
    Opjam.ME.play()

  pause: (event) ->
    event.preventDefault() unless event == undefined
    @$('.play').show()
    @$('.pause').hide()
    $("ul.ring li.track a.pause").hide()
    $("ul.ring li.track a.play").css('display', '')
    if @popupTrackId() == Opjam.ME.trackID
      $('#popup a.pause').hide()
      $('#popup a.play').show()
    Opjam.ME.pause()

  pushToPlay: (track_id) ->
    if Opjam.ME.trackID != track_id
      @model.set({currentTrackIndex: track_id})
      @setTrack track_id
    @updateTrackInfo(@model.currentTrack())
    @play()

  popupTrackId: ->
    $('#popup a.play').data('track_id')

  updateTrackInfo: (track) ->
    unless track == undefined
      name = track.get('name')
      @$('.info-bar').text name
      $('header .info').text name
      $('title').text "Opjam - #{name}"

  # TODO: this should be a template/view re-render
  setTrack: (id) ->
    audio_element = $('#player audio')[0]
    if audio_element.canPlayType('audio/mpeg')
      url = "/tracks/#{id}.mp3"
    else
      url = "/tracks/#{id}.oga"
    Opjam.ME.trackID = id
    Opjam.ME.setSrc url
    Opjam.ME.load()

  seekBarSlider: ->
    player = @model
    $('.seek-bar').slider
      min: 1
      max: 1000
      range: 'min'
      start: (event, ui) ->
        player.set({seeking: true})
      stop: (event, ui) ->
        player.set({seeking: false})
        Opjam.ME.setCurrentTime ui.value / 1000.0 * Opjam.ME.duration

  volumeBarSlider: ->
    $('.volume-bar').slider
      min: 1
      max: 100
      value: 100
      slide: (event, ui) ->
        Opjam.ME.setVolume ui.value / 100.0
