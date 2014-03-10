#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require handlebars
#= require_self
#= require_tree ../../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

window.Opjam =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  init: ->
    Opjam.router = new Opjam.Routers.OpjamRouter()
    Backbone.history.start()

jQuery ->
  Opjam.init()
