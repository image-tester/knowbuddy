class KyuEntry < ActiveRecord::Base
  acts_as_paranoid
  extend FriendlyId
  friendly_id :subject, use: :slugged
  acts_as_taggable_on :tags
  has_many :comments, dependent: :destroy
  belongs_to :user
  validates_presence_of :content, :subject, :slug
  default_scope order: 'created_at DESC'
  has_many :attachments, dependent: :destroy
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

