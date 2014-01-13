require "spec_helper"

describe "User" do
  before(:each) do
    User.delete_all!
    # debugger
    4.times do |n|
      @user = FactoryGirl.create(:user)
      (1..4).to_a.sample.times do |n|
        subject  = Faker::Name.name
        content  = "subject content"
        user_id  = @user.id
        KyuEntry.create(subject: subject,
                   content: content,
                   user_id: user_id)
      end
    end
  end

  it "should return top 3 contributors" do
    User.top3.should_not be_nil
    User.top3[3].should be_nil
    User.top3[0].total.should be >= User.top3[1].total
  end

  describe 'create_user_activity' do
    it 'should create user activity' do
      # user = FactoryGirl.create(:user)
      act = PublicActivity::Activity.find_by_owner_id(@user.id) && PublicActivity::Activity.find_by_key("user.create")
      act.should_not be_nil
    end
  end

  describe 'after_create' do
    it 'should run the proper callbacks' do
      user = FactoryGirl.create(:user)
      user.should_receive(:create_user_activity) #should pass
      user.run_callbacks(:create)
    end
  end
end

