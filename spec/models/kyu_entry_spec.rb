require 'spec_helper'

describe KyuEntry do

  describe 'Associations' do
    it { should belong_to :user }
    it { should have_many :attachments }
    it { should have_many :comments }
  end

   describe 'Database Columns' do
    it { should have_db_column(:subject).of_type(:string) }
    it { should have_db_column(:content).of_type(:text) }
    it { should have_db_column(:slug).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:publish_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
    it { should have_db_column(:deleted_at).of_type(:datetime) }
  end

  describe 'Validations' do
    it { should validate_presence_of :content }
    it { should validate_presence_of :subject }
    it { should validate_presence_of :slug }
  end

  describe 'scope::post_date' do
    before do
      4.times do |n|
        @user = create :user
        @kyu = create :kyu_entry, created_at: Time.now, user: @user
      end

      @user = create :user
      kyu = create :kyu_entry, created_at: 2.days.ago, user: @user
    end

    it "should return kyu's for date" do
      start = KyuEntry.first.created_at.to_date.beginning_of_day
      stop = KyuEntry.first.created_at.to_date.end_of_day
      kyu = KyuEntry.post_date(start, stop)
      kyu.count.should == 4
      KyuEntry.count.should == 5
    end
  end

  describe 'activity creation' do
    before do
      fetch_activity_type('kyu_entry.create')
      fetch_activity_type('kyu_entry.newTag')
      @user = create :user
      @kyu = create :kyu_entry, tag_list: "new tag after create", user: @user
    end

    describe 'create_new_tag_actvitiy' do
      it 'should create new_tag actvitiy on create' do
        act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.newTag")
        expect(act.parameters).not_to be_empty
        act.should_not be_nil
      end
    end

    describe 'update_kyu_entry_activity' do
      it 'should update kyu_entry activity' do
        fetch_activity_type('kyu_entry.update')
        @kyu.update_attributes(subject: "kyu update")
        act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.update")
        act.should_not be_nil
      end
    end

    describe 'destroy_kyu_entry_activity' do
      it 'should destroy kyu_entry activity' do
        fetch_activity_type('kyu_entry.destroy')
        @kyu.destroy
        act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.destroy")
        act.should_not be_nil
      end
    end
  end

  describe 'review callbacks' do
    let!(:kyu_entry) { create :kyu_entry }

    describe 'after_create' do
      it 'should run the proper callbacks' do
        kyu_entry.should_receive(:create_kyu_entry_activity)
        kyu_entry.run_callbacks(:create)
      end
    end

    describe 'around_save' do
      it 'should run the proper callbacks' do
        kyu_entry.should_receive(:create_new_tag_activity)
        kyu_entry.run_callbacks(:save)
      end
    end

    describe 'after_update' do
      it 'should run the proper callbacks' do
        kyu_entry.should_receive(:update_kyu_entry_activity)
        kyu_entry.run_callbacks(:update)
      end
    end

    describe 'before_destroy' do
      it 'should run the proper callbacks' do
        kyu_entry.should_receive(:destroy_kyu_entry_activity)
        kyu_entry.run_callbacks(:destroy)
      end
    end
  end
end
