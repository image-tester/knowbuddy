class ActivityType < ActiveRecord::Base
  attr_accessible :is_active, :activity_type

  has_many :activities, dependent: :destroy

  validates :activity_type, presence: true, uniqueness: true
  validates_inclusion_of :is_active, in: [true, false]
end
