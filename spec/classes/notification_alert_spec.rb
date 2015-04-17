require 'rails_helper'

describe "NotificationAlert" do
  describe "class methods" do
    before { ActionMailer::Base.deliveries = [] }
    let!(:rule1) { create(:no_post_in_week_rule) }
    let!(:rule2) { create(:general_rule) }
    let!(:user1) { create(:user) }

    describe 'post_alert' do
      it "sends post related mails to users falling in rule if
        passed rule is for 'posts'" do
        users_count = User.within_rule_range(rule1).to_a.count
        expect{
          NotificationAlert.post_alert(rule1)
        }.to change(ActionMailer::Base.deliveries, :count).
          by(users_count)
      end
    end

    describe 'general_alert' do
      it "sends general notification mail to all users if passed
        rule is for 'general'" do
        expect{
          NotificationAlert.general_alert(rule2)
        }.to change(ActionMailer::Base.deliveries, :count).
          by(User.count)
      end
    end
  end
end

