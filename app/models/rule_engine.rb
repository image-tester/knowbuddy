class RuleEngine < ActiveRecord::Base
  validates :rule, :subject, :rule_for, :frequency, presence: true
  validates :rule, uniqueness: true
  validates :min_count, :max_count, presence: true, uniqueness: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }, unless: :general_rule?
  validate :min_max_range , if: ["min_count.present?", "max_count.present?"]
  validates :body, presence: true, unless: :general_rule?
  validates :schedule, presence: true, unless: :daily_frequency?

  scope :active, -> { where(active: true) }

  def self.duration_array
    generate_options_array(RULE_ENGINE_DURATION_OPTIONS)
  end

  def self.frequency_array
    generate_options_array(RULE_ENGINE_SCHEDULE)
  end

  def self.generate_options_array(param)
    param.map { |v| [v, v.parameterize.underscore] }
  end

  def self.rule_for_array
    generate_options_array(RULE_ENGINE_PARAMS)
  end

  private

  def min_max_range
    if min_count >= max_count
      errors.add(:min_count, "max_count should be greater than min_count")
    end
  end

  def general_rule?
    rule_for == "general"
  end

  def daily_frequency?
    frequency == "daily"
  end
end
