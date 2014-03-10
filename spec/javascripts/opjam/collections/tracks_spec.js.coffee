describe "Tracks", ->

  beforeEach ->
    @tracks = new Opjam.Collections.Tracks()
    @firstTrack = new Opjam.Models.Track
        artist: 'first artist'
    @lastTrack = new Opjam.Models.Track
        artist: 'last artist'

  it "starts out empty", ->
    expect(@tracks.length).toEqual 0
    expect(@tracks.isEmpty).toBeTruthy()

  it "add elements as expected", ->
    @tracks.add @firstTrack
    expect(@tracks.length).toEqual 1

  it "should be able to retrieve elements by index", ->
    @tracks.add @firstTrack
    retrievedTrack = @tracks.at(0)
    expect(retrievedTrack).toBe @firstTrack

  it "should be able to remove elements", ->
    @tracks.add @firstTrack
    @tracks.remove @firstTrack
    expect(@tracks.length).toEqual 0

  describe "Tracks position", ->
    beforeEach ->
      @tracks.add @firstTrack
      @tracks.add @lastTrack

    describe "first", ->
      it "track", ->
        expect(@tracks.first()).toEqual @firstTrack

      it "returns its attributes", ->
        expect(@tracks.first().get('artist')).toEqual @firstTrack.get('artist')

    describe "last", ->
      it "track", ->
        expect(@tracks.last()).toEqual @lastTrack

      it "returns its attributes", ->
        expect(@tracks.last().get('artist')).toEqual @lastTrack.get('artist')
