class Opjam.Models.Wall extends Backbone.Model
  paramRoot: 'wall'

  defaults:
    numColumns: 46
    numRows: 4
    radius: 1000        # Radius of the virtual circle
    currentRotation: 10 # Initial position, measured in columns

  degreesPerColumn: =>
    360 / @numColumns()

  numColumns: =>
    @get("numColumns")

  radius: =>
    @get("radius")

  currentRotation: ->
    @get("currentRotation")

  incrementCurrentRotation: (increment) =>
    rotation = @get("currentRotation")
    @set {currentRotation: (rotation + increment)}

  currentRotationDegrees: -> # The current position, in columns * degrees per column
    @currentRotation() * @degreesPerColumn()

  thirdDimensionWall: ->
    wallType = window.location.href.match /wall=(.+)/
    wallType = wallType && wallType[1]
    if /^3D/.test wallType
      true
    else if /^flat/.test wallType
      false
    else
      $('html').hasClass 'webkit'

  display: (filter) ->
    $.when(
      Opjam.tracks.fetch()
      Opjam.users.fetch()
      Opjam.broadcasts.fetch()
    ).then =>
      if @thirdDimensionWall()
        wall = new Opjam.Views.WallView3D
          model: Opjam.wall
          collection: Opjam.plates
          filter: filter
      else
        wall = new Opjam.Views.WallView2D
          model: Opjam.wall
          collection: Opjam.plates
          filter: filter
      $(@el).append wall.render().el
    .fail =>
      console.log('model/wall:fail -> display @=',@)
