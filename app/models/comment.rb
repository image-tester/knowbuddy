class Comment < ActiveRecord::Base
  belongs_to :kyu_entry
  belongs_to :user
  validates_presence_of :comment

  attr_accessible :comment
end
