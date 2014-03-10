class Opjam.Views.WallView extends Backbone.View

  el: '#wall'

  events:
    "mouseenter #rotate_next" : "rotateNext"
    "mouseenter #rotate_prev" : "rotatePrev"
    "mouseleave #rotate_next" : "rotateStop"
    "mouseleave #rotate_prev" : "rotateStop"

  initialize: (options) ->
    @collection.on('reset', @render, @)
    @filter = options.filter

  render: ->
    $('#stage').empty()
    plates = _.shuffle(@plates())
    size = Math.floor plates.length / 4
    $.each @chunk(plates, size), (key, row) ->
      if row.length == size
        view = new Opjam.Views.RingRowView row: row
        $('#stage').append view.render().el
    $('footer').append(Opjam.bottomPlatesView.render().el)
    @initHoverInfo()
    @initPosition()
    @headerLinks()
    @

  initHoverInfo: ->
    self = @
    $('ul.ring').delegate 'li', 'mouseenter', (event) ->
      type = $(this).data('type')
      id = $(this).data('id')
      avatar = '<img width=22 height=22 class=avatar /><span class=name></span>'
      $('header .info').html(avatar)

      switch type
        when 'track'     then self.trackHoverInfo(id)
        when 'user'      then self.userHoverInfo(id)
        when 'broadcast' then self.broadcastHoverInfo(id)

    $('ul.ring').delegate 'li', 'mouseleave', (event) ->
      $('header .info').text $('#player .info-bar').text()

  trackHoverInfo: (id) =>
    trackData = Opjam.tracks.where({slug: id})[0]
    $('header .info img').attr('src', trackData.get('artwork').artwork.url)
    $('header .info .name').text(trackData.get('name'))

  broadcastHoverInfo: (id) =>
    broadcastData = Opjam.broadcasts.where({id: id})[0]
    $('header .info img').attr('src', broadcastData.get('image').url)
    $('header .info .name').text(broadcastData.get('title'))

  userHoverInfo: (id) =>
    userData = Opjam.users.where({username: id})[0]
    $('header .info img').attr('src', userData.get('active_avatar_url'))
    $('header .info .name').text(userData.get('username'))

  rotateStop: =>
    clearInterval(@timer)

  headerLinks: ->
    $('#flat_wall').click (event) ->
      event.preventDefault()
      wall_url = window.location.pathname + '?wall=flat' + window.location.hash
      window.location.replace(wall_url)

    $('#third_dimensional_wall').click (event) ->
      event.preventDefault()
      wall_url = window.location.pathname + '?wall=3D' + window.location.hash
      window.location.replace(wall_url)

  chunk: (plates, n) ->
    sets = []
    i = 0
    j = plates.length
    while i < j
      sets.push plates.slice(i, i + n)
      i += n
    sets

  plates: ->
    switch @filter
      when 'all'        then @collection.all()
      when 'profiles'   then @collection.profiles()
      when 'tracks'     then @collection.tracks()
      when 'broadcasts' then @collection.broadcasts()
      else @collection.models
