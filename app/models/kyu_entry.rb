class KyuEntry < ActiveRecord::Base
  extend FriendlyId
  friendly_id :subject, use: :slugged
  acts_as_taggable_on :tags
  has_many :comments, dependent: :destroy
  belongs_to :user
  validates_presence_of :content, :subject, :slug

  scope :post_date, lambda { |start, stop|
    where("created_at >= ? and created_at <= ?", start, stop)
  }

  paginates_per 10

  searchable do
    text :content, :subject
    text :comments do
      comments.map(&:comment)
    end
    text :user do
      user.name
    end
  end
end

