require 'spec_helper'

describe ActivityType do
  describe 'Associations' do
    it { should have_many :activities }
  end

  describe 'Callbacks' do
  end

  describe 'Factory' do
    ActivityType.where(activity_type: "test").delete_all
    it { expect(build(:activity_type)).to be_valid }
  end

  describe 'others' do

    it "is invalid without an activity_type" do
      FactoryGirl.build(:activity_type, activity_type: nil).should_not be_valid
    end

    it "is invalid without is_active" do
      FactoryGirl.build(:activity_type, is_active: nil).should_not be_valid
    end
  end

  describe 'Scopes' do
  end

  describe 'Validations' do
    ActivityType.where(activity_type: "test").delete_all
    context "activity_type" do
      it { should validate_presence_of :activity_type }
    end

  end
end
