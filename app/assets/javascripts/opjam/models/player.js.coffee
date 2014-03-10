class Opjam.Models.Player extends Backbone.Model

  defaults:
    currentTrackIndex: null
    seeking: false

  currentTrack: ->
    Opjam.tracks.where({slug: @get('currentTrackIndex')})[0]

  currentUserLastTrack: ->
    if Opjam.currentUser
      tracks = Opjam.currentUser.get('tracks')
      if tracks
        lastTrack = tracks[tracks.length-1]
        @set({currentTrackIndex: lastTrack?.slug})
        Opjam.tracks.where({slug: lastTrack?.slug})[0]

  createMediaElement: ->
    if Opjam.ME == undefined
      self = @
      el = $('footer').find('#player audio').get(0)
      Opjam.ME = new MediaElement el,
        enablePluginDebug: false
        plugins: [ 'flash', 'silverlight' ]
        type: ''
        pluginPath: '/assets/mediaelement/'
        flashName: 'flashmediaelement.swf'
        silverlightName: 'silverlightmediaelement.xap'
        features: ['playpause','progress','current','duration','tracks','volume']
        pauseOtherPlayers: true
        alwaysShowHours: true
        showTimecodeFrameCount: true
        success: (me, domObject) ->
          me.addEventListener 'timeupdate', ((e) ->
            $('#player .time').text self.secondsToTime(Opjam.ME.currentTime, true)
            $('.seek-bar').slider 'value', me.currentTime * 1000.0 / me.duration unless self.get('seeking')
          ), false
        error: (e) ->
          console.log('DBG: models/player -> createME/error: @=',@,'e=',e)

  secondsToTime: (time, forceHours, showFrameCount, fps) ->
    if typeof showFrameCount is "undefined"
      showFrameCount = false
    else fps = 25  if typeof fps is "undefined"
    hours = Math.floor(time / 3600) % 24
    minutes = Math.floor(time / 60) % 60
    seconds = Math.floor(time % 60)
    frames = Math.floor(((time % 1) * fps).toFixed(3))
    # TODO: Clean this stuff
    result = ((if (forceHours or hours > 0) then ((if hours < 10 then "0" + hours else hours)) + ":" else "")) + ((if minutes < 10 then "0" + minutes else minutes)) + ":" + ((if seconds < 10 then "0" + seconds else seconds)) + ((if (showFrameCount) then ":" + ((if frames < 10 then "0" + frames else frames)) else ""))
    result
