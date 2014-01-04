require 'spec_helper'

describe KyuEntry do
  before(:each) do
  User.delete_all!
  KyuEntry.delete_all!
    4.times do |n|
      @user = FactoryGirl.create(:user)
        subject  = Faker::Name.name
        content  = "subject content"
        user_id  = @user.id
        @kyu = KyuEntry.create(subject: subject,
                   content: content,
                   user_id: user_id,
                   created_at: Time.now)
    end
    1.times do |n|
      @user = FactoryGirl.create(:user)
        subject  = Faker::Name.name
        content  = "subject content"
        user_id  = @user.id
        KyuEntry.create(subject: subject,
                   content: content,
                   user_id: user_id,
                   created_at: "2011-08-08 09:01:39")
    end
  end

  it "should return kyu's for date'" do
    start = KyuEntry.first.created_at.to_date.beginning_of_day
    stop = KyuEntry.first.created_at.to_date.end_of_day
    kyu = KyuEntry.post_date(start, stop)
    kyu.count.should == 4
    KyuEntry.count.should == 5
  end

  describe 'create_kyu_entry_activity' do
    it 'should create kyu_entry activity' do
      @kyu = FactoryGirl.create(:kyu_entry)
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.create")
      act.should_not be_nil
    end
  end

  describe 'create_new_tag_actvitiy' do
    it 'should create new_tag actvitiy on create' do
      @kyu = FactoryGirl.create(:kyu_entry, subject: "key create", tag_list: "new tag after create")
      #tag_list = @kyu.tag_list
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.newTag")
      expect(act.parameters).not_to be_empty
      act.should_not be_nil
    end

    it 'should create new_tag actvitiy on update' do
      @kyu.update_attributes(subject: "kyu update", tag_list: "new tag after update")
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.newTag")
      expect(act.parameters).not_to be_empty
      act.should_not be_nil
    end
  end

  describe 'update_kyu_entry_activity' do
    it 'should update kyu_entry activity' do
      @kyu.update_attributes(subject: "kyu update")
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.update")
      act.should_not be_nil
    end
  end

  describe 'destroy_kyu_entry_activity' do
    it 'should destroy kyu_entry activity' do
      @kyu.destroy
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("kyu_entry.destroy")
      act.should_not be_nil
    end
  end

  describe 'after_create' do
    it 'should run the proper callbacks' do
      kyu_entry = FactoryGirl.create(:kyu_entry)
      kyu_entry.should_receive(:create_kyu_entry_activity)
      kyu_entry.run_callbacks(:create)
    end
  end

  describe 'around_save' do
    it 'should run the proper callbacks' do
      kyu_entry = FactoryGirl.create(:kyu_entry)
      kyu_entry.should_receive(:create_new_tag_activity)
      kyu_entry.run_callbacks(:save)
    end
  end

  describe 'after_update' do
    it 'should run the proper callbacks' do
      kyu_entry = FactoryGirl.create(:kyu_entry)
      kyu_entry.should_receive(:update_kyu_entry_activity)
      kyu_entry.run_callbacks(:update)
    end
  end

  describe 'before_destroy' do
    it 'should run the proper callbacks' do
      kyu_entry = FactoryGirl.create(:kyu_entry)
      kyu_entry.should_receive(:destroy_kyu_entry_activity)
      kyu_entry.run_callbacks(:destroy)
    end
  end
end