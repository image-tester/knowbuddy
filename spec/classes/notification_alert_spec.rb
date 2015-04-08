require 'rails_helper'

describe "NotificationAlert" do
  describe "class methods" do
    describe "send_notifications" do
      let!(:rule1) { create(:no_post_in_week_rule) }
      let!(:user1) { create(:user) }

      it "calls 'post_alert' method for sending post related mails to users if passed rule is for 'posts'" do
        NotificationAlert.send_notifications(rule1)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end
end

