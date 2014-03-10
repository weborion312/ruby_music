require 'spec_helper'

describe Track do

  it { should belong_to(:user) }

  describe 'validation' do
    context 'with no media' do
      subject { Track.make :media => nil }
      it { should_not be_valid }
    end

    context 'with an MP3 file' do
      subject { Track.make! :media => File.open('spec/support/empty.mp3') }
      it { should be_valid }
    end

    context 'with an Ogg Vorbis file' do
      subject { Track.make! :media => File.open('spec/support/example.ogg') }
      it { should be_valid }
    end
  end

  describe 'after_save default artwork image' do
    subject {Track.make!(:artwork => nil) }
    its(:artwork) { should_not == nil}
    its(:artwork_url) {should =~ /no_image_icon.png/}
  end

  context 'with play events' do
    subject { Track.make! }

    before do
      2.times do
        subject.event_logs.create!(
          :user => User.make!,
          :ip => '1.2.2.1',
          :event_type => :track_play
        )
      end
    end

    its(:plays) { should == 2 }
  end

  describe 'Media awareness' do
    subject { Track.make! }
    its(:duration) { should be_a Integer }
  end

  describe 'public scope' do
    let!(:unpulled) { Track.make! :pulled => false }
    let!(:pulled) { Track.make! :pulled => true }
    let!(:private) { Track.make! :private => true }

    it 'should include unpulled tracks' do
      Track.public.should include unpulled
    end

    it 'should not include pulled tracks' do
      Track.public.should_not include pulled
    end

    it 'should not include private tracks' do
      Track.public.should_not include private
    end
  end

  describe 'when tracks are being' do
    subject { Track.make! :private => private }

    describe 'published' do
      let(:private) { true }
      before { subject.publish! }
      its(:private) { should be_false }
    end

    describe 'unpublished' do
      let(:private) { false }
      before { subject.unpublish! }
      its(:private) { should be_true }
    end
  end

  describe 'given an existing public track' do
    subject { Track.make! :private => false }

    context 'when pulled' do
      before { subject.pull! }
      its(:public?) { should be_false }
    end

    context 'when pulled status is toggled and unpublished' do
      before { subject.toggle_pulled! }
      before { subject.unpublish! }
      its(:public?) { should be_false }
    end

    context 'when published' do
      before { subject.publish! }
      its(:public?) { should be_true }
    end
  end

  describe '#display_name' do
    context 'with a blank artist field' do
      before { subject.artist = '' }
      before { subject.name = 'Foo' }
      its(:display_name) { should eq 'Foo' }
    end

    context 'with an artist the same as the name' do
      before { subject.artist = 'Foo' }
      before { subject.name = 'Foo' }
      its(:display_name) { should eq 'Foo' }
    end

    context 'with an artist different to the name' do
      before { subject.artist = 'Foo' }
      before { subject.name = 'Bar' }
      its(:display_name) { should eq 'Foo - Bar' }
    end
  end
end
