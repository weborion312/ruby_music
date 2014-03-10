class Opjam.Views.BroadcastRingView extends Backbone.View

  template: JST['broadcast_ring/index']
  tagName: 'li'
  className: 'broadcast poster'

  initialize: ->
    @model.on('reset', @render, @)

  render: ->
    $(@el).attr('data-type', 'broadcast')
    $(@el).attr('id', 'broadcast_'+@model.get('id'))
    $(@el).attr('data-id', @model.get('id'))

    $(@el).html(@template(broadcast: @model.toJSON()))
    @
