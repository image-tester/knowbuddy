class RuleEngine < ActiveRecord::Base
  before_validation :set_value
  attr_accessor :schedule_time, :schedule_day, :schedule_date
  attr_accessible :active, :frequency, :mail_for, :min_post, :name, :rule_for, :schedule, :schedule_time, :schedule_day, :schedule_date

  # before_save :set_values

  validates :name, presence: true


  def self.rule_for_array
    [["Post","post"],["Comment","comment"],["Activity","activity"]]
  end

  def self.mail_for_array
    [["Top 3 Contributors", "top_3_contributors"],["Recent Activities", "recent_activities"]]
  end

  def self.frequency_array
    [["Daily", "daily"], ["Weekly", "weekly"], ["Monthly", "monthly"]]
  end

  private

    def set_value
      self.schedule =
        case self.frequency
        when "daily" then '6:00'
        when "weekly" then schedule_day
        when "monthly" then schedule_date
        end
    end
end
