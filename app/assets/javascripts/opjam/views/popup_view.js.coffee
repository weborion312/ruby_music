class Opjam.Views.PopupView extends Backbone.View

  el: "#popup"

  events:
    "click .show"           : "open"
    "click .links a"        : "passthru"
    "click .close"          : "close"
    "click #content a"      : "fetch"
    "submit"                : "submitForm"
    "click #popup a.play"   : "popupPlayerPlay"
    "click #popup a.pause"  : "popupPlayerPause"

  initialize: ->
    ZeroClipboard.setMoviePath "/assets/zeroclipboard/ZeroClipboard.swf"
    @model.bind 'change', @render

  passthru: (ev)->
    window.location = ev.target.href
    return false

  open: =>
    $(@el).show()

  close: =>
    $(@el).hide()
    # We are passing this event through, as a.close has href="#"
    # This resets our popup url

  setWidth: (width) =>
    #$(@el).width(width)
    #$(@el).css('margin-left', -width/2)

  render: =>
    @open()
    @model.html
    $(@el).html @model.html
    $(".chosen").chosen()
    #@setWidth($(@el).innerWidth() + ($(@el).width() - @el.clientWidth))
    $('form[enctype="multipart/form-data"]').submit ->
      container = $('<div class="spinner"></div>').appendTo(this)
      container.css('width', '22px')
      container.css('height', '22px')
      spinner = new Spinner({
        lines: 12,
        length: 4,
        width: 2,
        radius: 4,
        color: '#aaa',
        speed: 1,
        trail: 60,
        shadow: false
      }).spin(container.get(0))
    $('span.hint').tipsy()
    VSA_initScrollbars()
    # @zeroClipboard()

  submitForm: (ev)=>
    @model.submitForm ev.target
    false

  fetch: (ev)=>
    if ev.target.hash.length > 0
      Opjam.router.navigate(ev.target.hash.substr(1), true)
      false
    else if ev.target.pathname.match(/^\/users\/auth\//)
      true # OmniAuth authentication link
    else if ev.target.href.match(/^javascript:/)
      true # JavaScript link
    else
      Opjam.router.navigate("!/" + ev.target.pathname.substr(1), true)
      false

  popupPlayerPlay: (event) ->
    event.preventDefault()
    Opjam.playerView.pushToPlay @$('a.play').data('track_id')

  popupPlayerPause: (event) ->
    event.preventDefault()
    Opjam.playerView.pause()

  zeroClipboard: ->
    clip = new ZeroClipboard.Client()
    clip.setText ""
    clip.setHandCursor true
    clip.setCSSEffects true
    clip.setText $("clip_text").value
    clip.glue 'd_clip_button', 'd_clip_container'

  broadcasts: ->
