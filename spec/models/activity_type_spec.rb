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

  describe 'Instance Methods' do
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

  describe 'Validations' do
    it { should validate_presence_of(:activity_type) }
    it { should validate_uniqueness_of(:activity_type) }
    it { should allow_value(true, false).for(:is_active) }
  end

  describe 'Class Methods' do
    describe '.get_type(key)' do
      it 'should return the matched record' do
        activity = create :activity
        activity_type = create :activity_type, activity_type: "test.create"
        expect(ActivityType.get_type(activity.key)).to eq activity_type
      end
    end
  end
end
