describe "Track", ->

  beforeEach ->
    @track = new Opjam.Models.Track()

  it "can be instantiated", ->
    expect(@track).toBeTruthy()

  it "has the default properties", ->
    expect(@track.get('artist')).toEqual("No Artist Name")

  it "has the description property", ->
    @track.set({ artist: "Bob Dylan"})
    expect(@track.get('artist')).toEqual("Bob Dylan")

  it "has the done property", ->
    @track.set({ done: true})
    expect(@track.get('done')).toBeTruthy()
