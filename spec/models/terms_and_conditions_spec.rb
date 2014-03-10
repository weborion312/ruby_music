require 'spec_helper'

describe TermsAndConditions do
  it "should return the current T&C of two active" do
    # current is defined as the most recent active T&C
    tc1 = TermsAndConditions.make!(:active => true)
    tc2 = TermsAndConditions.make!(:active => true)
    TermsAndConditions.current.should == tc2
  end
  it "should return the current T&C of one active, one inactive" do
    # current is defined as the most recent active T&C
    tc1 = TermsAndConditions.make!(:active => true)
    tc2 = TermsAndConditions.make!(:active => false)
    TermsAndConditions.current.should == tc1
  end
  it "should return the current T&C of two active, one inactive" do
    # current is defined as the most recent active T&C
    tc1 = TermsAndConditions.make!(:active => true)
    tc2 = TermsAndConditions.make!(:active => false)
    tc3 = TermsAndConditions.make!(:active => true)
    TermsAndConditions.current.should == tc3
  end
end
