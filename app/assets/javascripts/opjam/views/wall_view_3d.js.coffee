class Opjam.Views.WallView3D extends Opjam.Views.WallView

  render: ->
    super
    @rings = $("#wall .ring")
    @rotater = $("#rotate")[0]
    @setupWall()
    @setupImages()
    $('html').addClass 'third-dimension-wall'

  initPosition: ->
    transform = 'translateZ(1600px) rotateY(' + @model.currentRotationDegrees( ) + 'deg)'
    for ring in $("#wall .ring")
      @addTransformStyle(ring, transform)

  rotateNext: =>
    @rotate(1)
    @timer = setInterval (=>
      @rotate(1)
    ), 800

  rotatePrev: =>
    @rotate(-1)
    @timer = setInterval (=>
      @rotate(-1)
    ), 800

  rotate: (increment) =>
    @performRotate(
      @model.degreesPerColumn() * increment,
      @model.currentRotationDegrees()
    )
    @model.incrementCurrentRotation(increment)

  performRotate: (increment, current) ->
    current = current + increment
    transform = 'translateZ(1600px) rotateY(' + current + 'deg)'
    for ring in @rings
      @addTransformStyle(ring, transform)

  setupWall: =>
    $("#stage").css "width", "0px"
    $("#wall").css "overflow", "visible"
    $("#stage .ring li")
      .css("position", "absolute")
      .css("display", "block")
      .css("width", "1px")

  setupImages: ->
    for ring in $("#wall .ring")
      for plate, i in $("li", ring)
        transform = 'rotateY(' + (-@model.degreesPerColumn() * i) + 'deg) translateZ(' + -1 * @model.radius() + 'px)'
        @addTransformStyle(plate, transform)
        $(plate).addClass("poster")

  addTransformStyle: (element, transform) ->
    element.style.transform       = transform
    element.style.webkitTransform = transform
    element.style.MozTransform    = transform

