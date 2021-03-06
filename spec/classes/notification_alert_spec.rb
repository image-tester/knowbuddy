require 'rails_helper'

describe "NotificationAlert" do
  describe "class methods" do
    before { ActionMailer::Base.deliveries = [] }
    let!(:rule1) { create(:no_post_in_week_rule) }
    let!(:rule2) { create(:general_rule) }
    let!(:user1) { create(:user) }

    describe "posts_notification" do
      it "sends post related mails to users falling in rule if
        passed rule is for 'posts'" do
        users_count = User.within_rule_range(rule1).to_a.count
        expect{
          NotificationAlert.posts_notification(rule1)
        }.to change(ActionMailer::Base.deliveries, :count).by(users_count)
      end
    end

    describe "top_contributors_notification" do
      before do
        3.times do |n|
          user = create :user
          user.posts = create_list :post, n, user: user
        end
      end

      it "sends top contributors notification mail to all users if passed
        rule is 'general' and top contributors exists" do
        expect{
          NotificationAlert.top_contributors_notification(rule2)
        }.to change(ActionMailer::Base.deliveries, :count).by(User.count)
      end
    end
  end
end

