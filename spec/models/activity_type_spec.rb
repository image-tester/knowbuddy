require 'spec_helper'

describe ActivityType do
  describe 'Database Columns' do
    it { should have_db_column(:activity_type).of_type(:string) }
    it { should have_db_column(:is_active).of_type(:boolean) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

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

  describe 'instance methods' do
    let(:type) { create :activity_type }

    describe 'activate' do
      it 'should mark is_active true' do
        type.activate
        type.is_active.should be_true
      end
    end

    describe 'deactivate' do
      it 'should mark is_active false' do
        type.deactivate
        type.is_active.should be_false
      end
    end
  end
end
