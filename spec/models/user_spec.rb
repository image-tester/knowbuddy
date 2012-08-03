require "spec_helper"

describe "User" do
  before(:each) do
    4.times do |n|
      FactoryGirl.create(:user)
      @user = Factory(:user)
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

end

