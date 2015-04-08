class Utility
  def self.schedule_for_today?(frequency, schedule)
    todays_date = Date.today
    scheduled_day = schedule.to_date.wday
    scheduled_days = case frequency
      when ("weekly") then (scheduled_day == todays_date.wday) ? [todays_date] : []
      when "monthly" then [find_first_scheduled_day(scheduled_day)]
      when "once_in_2_weeks" then [find_first_scheduled_day(scheduled_day), find_first_scheduled_day(scheduled_day) + 14]
      end
    scheduled_days.include?(todays_date)
  end

  #code to find first scheduled week day in month
  def self.find_first_scheduled_day(scheduled_day)
    first_day = Date.today.beginning_of_month
    #if first day of month is before scheduled week day
    if (first_day.wday < scheduled_day)
      #find scheduled date by adding their difference to first day
      (first_day + (scheduled_day-first_day.wday))
    else
      #else find scheduled date by adding difference between first day and next scheduled week day to first day
      (first_day + (7 - (first_day.wday - scheduled_day)))
    end
  end
end
