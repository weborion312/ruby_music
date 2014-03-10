# OpJam JavaScript

## [coffeescript](http://jashkenas.github.com/coffee-script/)
Coffeescript is the language used for Javascript code.

## Structure

### Vendor / External libraries
These files should go in `App root + '/vendor/assets/javascripts/'`

## Libraries
All libraries should be mentioned here before including them (and
removed if removed!). Much better with a bit of description of why you
are adding it...

### misc
* css_browser_selector
* jquery
* jquery-ui
* jquery_ujs
* jquery.animate-enhanced.min
* chosen.jquery.min
* jquery.form
* spin.min
* mediaelement/mediaelement.min (Media/Audio/Player stuff)
* jquery.tipsy
* ZeroClipboard (flash click copy plugin)
* vscrollarea (required for popups scrolls)

### opjam/app (backbone app)
* underscore
* backbone
* backbone_rails_sync
* backbone_datalink
* handlebars

### [Backbone](http://documentcloud.github.com/backbone/)
`Opjam` front-end is in most part a backbone application. Therefore
most if not all js related code should live within it.

#### Wall
`WallView`:
* Handles MouseEnter and MouseLeave events.
* Sends the users and tracks sets of rings to crete the `RingViews` (ATM 4).

`RingView`:
* Renders the wall plates `<ul class="ring">`
* Sends a `hash` mixed with users and tracks to create the
  `UserRingView`s and `TrackRingView`s for each ring.

`UserRingView` and `TrackRingView`:
* renders the user and tracks ring data.
