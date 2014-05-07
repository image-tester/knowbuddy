require "spec_helper"

describe "User" do
  describe 'scope::top3' do
    before do
      4.times do |n|
        user = create :user
        user.posts = create_list :post, n, user: user
      end
    end

    it "should return top 3 contributors" do
      User.top3.should_not be_nil
      User.top3[3].should be_nil
      User.top3[0].total.should be >= User.top3[1].total
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
