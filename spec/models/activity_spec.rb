require 'rails_helper'

describe Activity do
  describe 'Associations' do
    it { should belong_to :activity_type }
  end

  describe 'Database Columns' do
    it { should have_db_column(:trackable_id).of_type(:integer) }
    it { should have_db_column(:trackable_type).of_type(:string) }
    it { should have_db_column(:owner_id).of_type(:integer) }
    it { should have_db_column(:owner_type).of_type(:string) }
    it { should have_db_column(:key).of_type(:string) }
    it { should have_db_column(:parameters).of_type(:text) }
    it { should have_db_column(:recipient_id).of_type(:integer) }
    it { should have_db_column(:recipient_type).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
    it { should have_db_column(:activity_type_id).of_type(:integer) }
  end

  describe 'Factory' do
    it { expect(build(:activity)).to be_valid }
  end

  describe 'Class Methods' do

    describe 'latest_activities'do
      it 'should join in order' do
        activity1 = create :activity, created_at: 2.days.ago
        activity2 = create :activity, created_at: 1.day.ago,
          activity_type: (create :inactive)
        activity3 = create :activity, created_at: Time.now
        latest_activities = Activity.latest_activities(1,3)
        expect(latest_activities).to eq [activity3, activity1]
        expect(latest_activities).to_not include activity2
      end
    end

    describe 'from_past_24_hrs' do
      let(:activity1) { create :activity, created_at: 25.hours.ago }
      let(:activity2) { create :activity, created_at: 23.hours.ago,
        activity_type: (create :inactive) }
      let(:activity3) { create :activity, created_at: 23.hours.ago }

      it 'should return all active activities in last 1 day' do
        recent_activities = Activity.from_past_24_hrs
        expect(recent_activities).to eq [activity3]
        expect(recent_activities).to_not include activity1,activity2
      end
    end

    describe 'with_active_activity_types' do
      let(:activity1) { create :activity }
      let(:activity2) { create :activity, activity_type: (create :inactive) }

      it 'should return all active activities' do
        expect(Activity.with_active_activity_types).to include activity1
        expect(Activity.with_active_activity_types).to_not include activity2
      end
    end

    describe 'add_activity(action, record)' do
      it 'should add new activity with owner as user' do
        user = create :user
        activity = Activity.add_activity('create', user)
        expect(Activity.count).to eq(2)
        expect(activity).to eq true
      end

      it 'should add new activity with owner as post' do
        post = create :post
        activity = Activity.add_activity('create', post)
        expect(Activity.count).to eq(4)
        expect(activity).to eq true
      end
    end
  end
end
