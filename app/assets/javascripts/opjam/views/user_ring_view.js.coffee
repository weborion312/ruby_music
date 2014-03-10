class Opjam.Views.UserRingView extends Backbone.View

  template: JST['user_ring/index']
  tagName: 'li'
  className: 'user poster'

  initialize: ->
    @model.on('reset', @render, @)

  render: ->
    $(@el).attr('data-type', 'user')
    $(@el).attr('id', 'user_'+@model.get('id'))
    $(@el).attr('data-id', @model.get('username'))

    $(@el).html(@template(user: @model.toJSON()))
    @
