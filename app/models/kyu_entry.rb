class KyuEntry < ActiveRecord::Base
  attr_accessible :content, :created_at, :publish_at, :subject,
    :tag_list, :updated_at

  belongs_to :user
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :content, :subject, :slug

  acts_as_paranoid
  acts_as_taggable_on :tags
  extend FriendlyId
  friendly_id :subject, use: :slugged
  paginates_per 10

  delegate :name, :email, to: :user, prefix: true

  scope :list, lambda { |user_id|
    where('user_id = ?', user_id)
  }

  default_scope order: 'created_at DESC'
  scope :post_date, lambda { |start, stop|
    where("created_at >= ? and created_at <= ?", start, stop)
  }

  searchable do
    text :content, :subject
    text :comments do
      comments.map(&:comment)
    end
    text :user do
      user.name unless user.blank?
    end
  end

  def to_s
    subject
  end

  def self.invalid_attachments
    attachments = Attachment.where(kyu_entry_id: nil)
    attachments.each {|attachment| attachment.destroy }
  end
end