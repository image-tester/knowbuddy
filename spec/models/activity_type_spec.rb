require 'spec_helper'

describe ActivityType do
  it "has a valid factory" do
  	FactoryGirl.create(:activity_type).should be_valid
  end

  it "is invalid without an activity_type" do
  	FactoryGirl.build(:activity_type, activity_type: nil).should_not be_valid
  end

  it "is invalid without is_active" do
  	FactoryGirl.build(:activity_type, is_active: nil).should_not be_valid
  end

  it "does not allow duplicate activity_type" do
  	FactoryGirl.create(:activity_type, activity_type: "kyu_entry.create").should be_valid
  	FactoryGirl.build(:activity_type, activity_type: "kyu_entry.create").should_not be_valid
  end
end
