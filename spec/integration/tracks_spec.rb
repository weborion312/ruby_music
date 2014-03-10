require "spec_helper"

describe "Tracks" do
  let!(:track) { Track.make! :media => File.open('spec/support/empty.mp3'),
    :oga => File.open('spec/support/empty.mp3'),
    :mp3 => File.open('spec/support/empty.mp3')
  }

  it "should successfully get the track's oga" do
    track.public?.should == true
    get track.media.url
    response.status.should  == 200
  end

  it "should fail to get the track's oga when it's private" do
    pending ''
    # track.unpublish!
    # get track.oga.url
    # response.status.should == 404
  end

  it "should successfully get the track's mp3" do
    track.public?.should == true
    get track.mp3.url
    response.status.should == 200
  end

  it "should fail to get the track's mp3 when it's private" do
    pending ''
    # track.unpublish!
    # get track.mp3.url
    # response.status.should == 404
  end

  it "should show the number of plays for a track" do
    EventLog.make!(:track => track, :event_type => :track_play)
    track.plays.should == 1
  end

  it "should show two of plays for a track" do
    EventLog.make!(:track => track, :event_type => :track_play)
    EventLog.make!(:track => track, :event_type => :track_play)
    track.plays.should == 2
  end
end
