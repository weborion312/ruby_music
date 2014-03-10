class Opjam.Views.WallView2D extends Opjam.Views.WallView

  initPosition: ->
    $('#stage').css('margin-left', '-140px')
    $('html').addClass 'flat-wall'

  rotateStop: =>
    window.rotating = false
    super

  rotatePrev: =>
    window.rotating = true
    $('ul.ring').each ->
      rotate = (ring) ->
        $(ring).animate({ marginLeft: '138px' }, 800, 'linear', ->
          $(ring).find('li').last().prependTo $(ring)
          $(ring).css 'margin-left', '0'
          rotate(ring) if window.rotating
        )
      rotate(this)

  rotateNext: =>
    window.rotating = true
    $('ul.ring').each ->
      rotate = (ring) ->
        $(ring).animate({ marginLeft: '-138px' }, 800, 'linear', ->
          $(ring).find('li').first().appendTo $(ring)
          $(ring).css 'margin-left', '0'
          rotate(ring) if window.rotating
        )
      rotate(this)
