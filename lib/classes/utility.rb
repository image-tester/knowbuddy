class Utility
  def self.schedule_for_today?(frequency, schedule)
    today = Date.today
    scheduled_day = schedule.to_date.wday
    scheduled_days = case frequency
      when "weekly" then ([today] if scheduled_day == today.wday)
      when "monthly" then [find_first_scheduled_day(scheduled_day)]
      when "once_in_2_weeks" then [find_first_scheduled_day(scheduled_day), find_first_scheduled_day(scheduled_day) + 14]
      end
    scheduled_days.include?(today)
  end

  def self.find_first_scheduled_day(scheduled_day)
    first_day = Date.today.beginning_of_month
    (first_day.wday < scheduled_day) ? (first_day + (scheduled_day-first_day.wday)) : (first_day + (7 - (first_day.wday - scheduled_day)))
  end
end
