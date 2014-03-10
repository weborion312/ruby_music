class Opjam.Views.RingRowView extends Backbone.View

  tagName: 'ul'
  className: 'ring'

  initialize: (options) ->
    @row = options.row

  render: ->
    @addRingClass()
    _.each @row, (ring) ->
      switch ring.get('klass')
        when 'Track'     then view = new Opjam.Views.TrackRingView(model: ring)
        when 'User'      then view = new Opjam.Views.UserRingView(model: ring)
        when 'Broadcast' then view = new Opjam.Views.BroadcastRingView(model: ring)

      $('ul.ring').last().append(view.render().el)
    @

  addRingClass: ->
    # TODO: there should be a better way to do this...
    if $('#stage ul.ring').length == 0
      $('#stage').append('<ul class="ring"></div>')
