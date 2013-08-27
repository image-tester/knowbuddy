require 'spec_helper'

describe KyuEntry do
  before(:each) do
  User.delete_all!
    4.times do |n|
      @user = FactoryGirl.create(:user)
        subject  = Faker::Name.name
        content  = "subject content"
        user_id  = @user.id
        KyuEntry.create(subject: subject,
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
end