class RuleEngine < ActiveRecord::Base
  attr_accessible :active, :frequency, :mail_for, :min_post, :name, :rule_for, :schedule

  validates :name, presence: true
  def self.rule_for_array
    [["Post","Post"],["Comment","Comment"],["Activity","Activity"]]
  end

  def self.mail_for_array
    [["Top 3 Contributors", "top_3_contributors"],["Recent Activities", "recent_activities"]]
  end
end
