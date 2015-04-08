require 'rails_helper'

describe 'Utility' do
  describe 'schedule_for_today?' do
    let!(:weekly_rule) { create(:rule_engine, frequency: "weekly") }

    it "should return true if schedule is for todays date else return false" do
      if weekly_rule.schedule.to_date == Date.today
        expect(Utility.schedule_for_today?(weekly_rule.frequency,weekly_rule.schedule)).to be_truthy
      else
        expect(Utility.schedule_for_today?(weekly_rule.frequency,weekly_rule.schedule)).to be_falsy
      end
    end
  end

  describe "find_first_scheduled_day" do
    let!(:rule1) { create(:rule_engine, frequency: "once_in_2_weeks", schedule: "Monday") }
    let!(:rule2) { create(:rule_engine, frequency: "monthly", schedule: "Monday") }

    it "should return first and third scheduled days in month if rule frequency is once_in_2_weeks" do
      if ((Date.today.day <= 7) && (rule1.schedule.to_date == Date.today))
        expect(Utility.find_first_scheduled_day(rule1.schedule.to_date.wday)).to eq([Date.today, Date.today + 14])
      end
    end

    it "should return first scheduled day in month if rule frequency is monthly" do
      if ((Date.today.day <= 7) && (rule2.schedule.to_date == Date.today))
        expect(Utility.find_first_scheduled_day(rule2.schedule.to_date.wday)).to eq([Date.today])
      end
    end
  end
end
