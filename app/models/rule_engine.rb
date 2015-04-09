class RuleEngine < ActiveRecord::Base
  #before_validation :set_rule_values
  validates :rule, :subject, :body, :rule_for, :frequency, presence: true
  validates :rule, uniqueness: true
  validates :min_count, :max_count, presence: true, unless: :top_3_contributors_rule?
  validate :min_max_range , if: ["min_count.present?", "max_count.present?"]

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
  # def set_rule_values
  #   case rule_for
  #   when "top_3_contributors" then self.min_count = nil
  #   when "top_3_contributors" then self.max_count = nil
  #   end
  # end

  def min_max_range
    if min_count > max_count
      errors.add(:min_count, "max_count should not be less than min_count")
    end
  end

  def top_3_contributors_rule?
    rule_for == "top_3_contributors"
  end
end
