class Comment < ActiveRecord::Base
  belongs_to :kyu_entry
  belongs_to :user
  validates_presence_of :comment
  default_scope order: 'created_at DESC'
end

