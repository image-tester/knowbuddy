require 'spec_helper'

describe ActivityType do
  describe 'Factory' do
    it { expect(build(:activity_type)).to be_valid }
  end

  describe 'others' do
    it "is invalid without an activity_type" do
      activity = build :activity_type, activity_type: nil
      activity.should_not be_valid
    end

    it "is invalid without is_active" do
      activity = build :activity_type, is_active: nil
      activity.should_not be_valid
    end
  end
end
