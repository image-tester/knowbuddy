class Utility
  def self.schedule_for_today?(frequency, schedule)
    today = Date.today
    current_day = Date::DAYNAMES[today.wday]
    scheduled_days = []
    if (frequency == "weekly" && schedule == current_day)
      scheduled_days << today
    end
    if ((frequency == "monthly") || (frequency == "once_in_2_weeks"))
      first_day = today.beginning_of_month
      scheduled_day = schedule.to_date.wday
      scheduled_days << ((first_day.wday < scheduled_day) ? (first_day + (scheduled_day-first_day.wday)) : (first_day + (8-scheduled_day)))
    end
    if (frequency == "once_in_2_weeks")
      scheduled_days << (scheduled_days[0] + 14)
    end
    scheduled_days.include?(today)
  end
end
