require 'spec_helper'

describe EventLog do
  it "records an event" do
    u = User.make!
    expect { EventLog.create!(:event_type => :track_play, :user => u, :ip => "127.0.0.1") }.to change{ EventLog.count }.by(1)
  end
  it "ensures event type is only of :track_play" do
    u = User.make!
    EventLog.new(:event_type => :rubbish, :user => u, :ip => "127.0.0.1").should_not be_valid
  end
end
