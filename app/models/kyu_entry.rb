class KyuEntry < ActiveRecord::Base
  MINFONTSIZE = 10
  MAXFONTSIZE = 23

  attr_accessible :content, :created_at, :publish_at, :subject,
    :tag_list, :updated_at, :user_id

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
      comments.map { |c| c.user.name }
      comments.map(&:comment)
    end
    text :user do
      user.name unless user.blank?
    end
    text :tags do
      tags.map {|tag| tag.name}
    end
  end

  def to_s
    subject
  end

  def self.invalid_attachments
    attachments = Attachment.where(kyu_entry_id: nil)
    attachments.each {|attachment| attachment.destroy }
  end
# Added on 23rd April 2012 by yatish to display cloud tag
# Start
  def self.tag_cloud
    tags = self.tag_counts.order('count Desc').limit(20)
    if tags.length > 0
      maxOccurs = tags.first.count
      minOccurs = tags.last.count
      @tag_cloud_hash = {}
      tags.each do |tag|
        weight = (tag.count - minOccurs).to_f / (maxOccurs - minOccurs)
        size = MINFONTSIZE + ((MAXFONTSIZE - MINFONTSIZE) * weight)
        @tag_cloud_hash[tag] = size if size > 4
      end
    end
    return @tag_cloud_hash
  end
end