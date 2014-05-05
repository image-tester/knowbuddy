class KyuEntry < ActiveRecord::Base
  include PublicActivity::Common

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

  after_create :create_kyu_entry_activity
  after_update :update_kyu_entry_activity
  before_create :set_publish_date
  before_destroy :destroy_kyu_entry_activity, if: "deleted_at.blank?"
  around_save :create_new_tag_activity

  scope :list, lambda { |user_id|
    where('user_id = ?', user_id)
  }

  default_scope order: 'created_at DESC'

  searchable do
    text :content, :subject
    time :publish_at
    time :created_at
    text(:user) { user.try(:name) }
    text(:tags) { tags.pluck(:name) }
    text(:comments) { comments.pluck(:comment) }
  end

  def to_s
    subject
  end

  def self.get_kyu(kyu_id)
    self.with_deleted.find(kyu_id)
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
    @tag_cloud_hash
  end

  def user
    User.with_deleted.find(user_id)
  end

  def self.search_kyu(search_key)
    search = Sunspot.search(KyuEntry) do
      fulltext search_key
      order_by :publish_at, :desc
    end
    search.results
  end

  def self.post_date(kyu)
    current_date = kyu.created_at.to_date
    where("created_at >= ? and created_at <= ?",
      current_date.beginning_of_day, current_date.end_of_day)
  end

  private
  def set_publish_date
    self.publish_at = Time.now
  end

  def create_kyu_entry_activity
    act_type = ActivityType.find_by_activity_type('kyu_entry.create')
    (self.create_activity :create, params: {"1"=> self.subject, "2"=> self.id})
    .tap{|a| a.owner_id = self.user_id; a.owner_type = 'User';
     a.activity_type_id = act_type.id; a.save} unless act_type.blank?
  end

  def create_new_tag_activity
    act_type = ActivityType.find_by_activity_type('kyu_entry.newTag')
    newTag = self.tag_list- ActsAsTaggableOn::Tag.pluck(:name)
    yield
    (self.create_activity key: 'kyu_entry.newTag', params: {"1"=> newTag})
    .tap{|a| a.owner_id = self.user_id; a.owner_type = 'User';
     a.activity_type_id = act_type.id; a.save} if(newTag.present? && act_type.present?)
  end

  def update_kyu_entry_activity
    act_type = ActivityType.find_by_activity_type('kyu_entry.update')
    (self.create_activity :update, params: {"1"=> self.subject, "2" => self.id})
    .tap{|a| a.owner_id = self.user_id; a.owner_type = 'User';
     a.activity_type_id = act_type.id; a.save}
  end

  def destroy_kyu_entry_activity
    act_type = ActivityType.find_by_activity_type('kyu_entry.destroy')
    (self.create_activity :destroy, params:{"1"=> self.subject, "2"=> self.id})
    .tap{|a| a.owner_id = self.user_id; a.owner_type = 'User';
     a.activity_type_id = act_type.id; a.save}
  end
end