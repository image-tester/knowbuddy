class RuleEngine < ActiveRecord::Base
  before_validation :set_value
  attr_accessor :schedule_time, :schedule_day, :schedule_date
  attr_accessible :active, :frequency, :mail_for, :min_post, :name, :rule_for, :schedule, :schedule_time, :schedule_day, :schedule_date


  validates :name, :rule_for, :frequency, presence: true
  validates :name, uniqueness: true


  def self.rule_for_array
    [["Post","post"],["Comment","comment"],["Activity","activity"]]
  end

  def self.mail_for_array
    [["Top 3 Contributors", "top_3_contributors"],["Recent Activities", "recent_activities"]]
  end

  def self.frequency_array
    [["Daily", "daily"], ["Weekly", "weekly"], ["Monthly", "monthly"]]
  end

  def self.date_array
    ((1..30).map {|i| ["#{i}", "#{i}"] })
  end

  def get_schedule_values
    case self.frequency
    when "daily" then self.schedule_time = schedule
    when "weekly" then self.schedule_day = schedule
    when "monthly" then self.schedule_date = schedule
    end
  end

  private

    def set_value
      self.schedule =
        case self.frequency
        when "daily" then schedule_time
        when "weekly" then schedule_day
        when "monthly" then schedule_date
        end
      case self.rule_for
      when "post" then self.mail_for = nil
      when "activity" then self.min_post = nil
      when "comment" then self.mail_for = self.min_post = nil
      end
    end
end
