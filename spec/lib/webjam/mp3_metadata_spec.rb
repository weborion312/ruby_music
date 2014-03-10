require 'spec_helper'
describe WebJam::Mp3Metadata do
  subject do
    Track.make
  end

  describe 'metadata extraction' do
    before do
      subject.media = File.open("spec/support/#{filename}")
      subject.save!
      subject.reload # ensure we're checking persisted data
    end

    context 'with empty.mp3' do
      let(:filename) { 'empty.mp3' }
      its(:duration) { should eq 2 }
      its(:name) { should eq 'empty' } # fallback
      its(:artist) { should be_nil }
      its(:tags) { should be_nil }
    end

    context 'with empty_v1.mp3' do
      let(:filename) { 'empty_v1.mp3' }
      its(:duration) { should eq 2 }
      its(:name) { should eq 'Test Title' }
      its(:artist) { should eq 'Test Artist' }
      its(:tags) { should be_nil }
    end

    context 'with empty_v22.mp3' do
      let(:filename) { 'empty_v23.mp3' }
      its(:duration) { should eq 3 }
      its(:name) { should eq 'Bar' }
      its(:artist) { should eq 'Foo' }
      its(:tags) { should eq 'Trip-Hop' }
    end

    context 'with empty_v23.mp3' do
      let(:filename) { 'empty_v23.mp3' }
      its(:duration) { should eq 3 }
      its(:name) { should eq 'Bar' }
      its(:artist) { should eq 'Foo' }
      its(:tags) { should eq 'Trip-Hop' }
    end

    context 'with empty_v24.mp3' do
      let(:filename) { 'empty_v24.mp3' }
      its(:duration) { should eq 3 }
      its(:name) { should eq 'Bar' }
      its(:artist) { should eq 'Foo' }
      its(:tags) { should eq 'Trip-Hop' }
    end

    context 'with empty.m4a' do
      let(:filename) { 'empty.m4a' }
      its(:duration) { should eq 2 }
      its(:name) { should eq 'AAC Test Track' }
      its(:artist) { should eq 'ABC' }
      its(:tags) { should eq 'Test' }
    end

    context 'with example.ogg' do
      let(:filename) { 'example.ogg' }
      its(:duration) { should eq 6 }
      its(:name) { should eq 'example' } # fallback
      its(:artist) { should be_nil }
      its(:tags) { should be_nil }
    end

    context 'with example_tagged.ogg' do
      let(:filename) { 'example_tagged.ogg' }
      its(:duration) { should eq 6 }
      its(:name) { should eq 'foo' }
      its(:artist) { should eq 'bar' }
      its(:tags) { should eq 'baz' }
    end
  end
end
