require 'rails_helper'

describe 'Utility' do
  describe 'schedule_for_today?' do
    let!(:weekly_rule) { create(:rule_engine, frequency: "weekly", schedule: "Tuesday") }

    it "should return true if schedule is for today" do
      allow(Date).to receive(:today).and_return("2015-04-14".to_date)
      expect(Utility.schedule_for_today?(weekly_rule.frequency,weekly_rule.schedule)).to be_truthy
    end

    it "should return false if schedule is not for today" do
      allow(Date).to receive(:today).and_return("2015-04-13".to_date)
      expect(Utility.schedule_for_today?(weekly_rule.frequency,weekly_rule.schedule)).to be_falsy
    end
  end

  describe "find_first_scheduled_day" do
    let!(:rule) { create(:rule_engine, frequency: "monthly", schedule: "Tuesday") }

    it "should return first scheduled day in month" do
      allow(Date).to receive(:today).and_return("2015-04-08".to_date)
      expect(Utility.find_first_scheduled_day(rule.schedule.to_date.wday)).to eq(Date.today.prev_day)
    end
  end
end
