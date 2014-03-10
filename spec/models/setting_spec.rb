require 'spec_helper'

describe Setting do
  describe 'validation' do
    [:wall_percentage_track, :wall_percentage_user].each do |field|
      it { should validate_numericality_of field }
      it { should allow_value(0).for(field) }
      it { should allow_value(50).for(field) }
      it { should allow_value(100).for(field) }
      it { should_not allow_value(-5).for(field) }
      it { should_not allow_value(105).for(field) }
      it { should_not allow_value(4.2).for(field) }
    end
  end

  describe 'single instance' do
    describe '.instance' do
      subject { Setting.instance }

      context 'with no existing record' do
        its(:new_record?) { should be_true }
      end

      context 'with an existing record' do
        before { Setting.make! }
        its(:new_record?) { should be_false }
      end
    end

    it 'should not allow creation of a second record' do
      Setting.make!
      Setting.new.should_not be_valid
    end
  end

  describe 'default values' do
    it 'should have a default value on a new record' do
      subject.wall_percentage_track.should == Setting::DEFAULTS[:wall_percentage_track]
    end

    it 'should persist custom value on existing record' do
      subject.wall_percentage_track = Setting::DEFAULTS[:wall_percentage_track] + 1
      subject.save!

      setting = ActiveRecord::IdentityMap.without { Setting.first } # new instance
      setting.wall_percentage_track.should eq Setting::DEFAULTS[:wall_percentage_track] + 1
    end
  end
end
