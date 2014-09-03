class ActivityType < ActiveRecord::Base
  attr_accessible :is_active, :activity_type

  has_many :activities, dependent: :destroy

  validates :activity_type, presence: true, uniqueness: true
  validates :is_active, inclusion: { in: [true, false] }

  def activate
    update_attribute :is_active, true
  end

  def deactivate
    update_attribute :is_active, false
  end

  def self.get_type(key)
    find_by_activity_type(key)
  end
end
