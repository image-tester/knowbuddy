class Comment < ActiveRecord::Base
  attr_accessible :comment, :created_at, :kyu_entry_id, :updated_at, :user_id

  belongs_to :kyu_entry
  belongs_to :user

  validates_presence_of :comment

  delegate :subject, to: :kyu_entry, prefix: true

  default_scope order: 'created_at DESC'
  scope :list, lambda { |user_id|
    where('id = ?', user_id)
  }
end
