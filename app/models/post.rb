class Post < ActiveRecord::Base
  include PublicActivity::Common
  acts_as_votable

  MINFONTSIZE = 10
  MAXFONTSIZE = 23

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

  after_create     :post_activity,          unless: "is_draft"
  after_update     :post_activity,          unless: "is_draft"
  before_destroy   :destroy_post_activity,  if: :destroy_activity?
  around_save      :create_new_tag_activity
  after_validation :set_is_draft
  after_validation :set_published
  after_save       :send_email_notification, if: "is_published_changed?"

  default_scope { order("created_at DESC") }
  scope :draft, -> { where(is_draft: true) }
  scope :published, -> { where(is_draft: false) }

  scope :active_published, -> { where("posts.is_draft IS FALSE OR
    posts.is_draft IS NULL") }
  scope :after_date_boundary, ->(boundary_date) { where("posts.
    created_at > ?", boundary_date) }

  searchable do
    text :content, :subject
    time :publish_at
    time :created_at
    text(:user) { user.try(:name) }
    text(:tags) { tags.pluck(:name) }
    text(:comments) { comments.pluck(:comment) }
  end

  def allowed?(current_user)
    published? || user == current_user
  end

  def published?
    !is_draft
  end

  def to_s
    subject
  end

  def self.get_post(post_id)
    self.with_deleted.friendly.find(post_id)
  end

  def self.invalid_attachments
    attachments = Attachment.where(post_id: nil)
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
    User.with_deleted.find(user_id) if user_id
  end

  def self.search_post(search_key)
    search = Sunspot.search(Post) do
      fulltext search_key
      order_by :publish_at, :desc
    end
    search.results
  end

  def self.post_date(post)
    current_date = post.updated_at.to_date
    where("updated_at >= ? and updated_at <= ?",
      current_date.beginning_of_day, current_date.end_of_day)
  end

  def activity_params
    { post_subject: subject, post_id: id }
  end

  def vote_activity(action, user)
    action = action == 'like' ? 'like' : 'dislike'
    Activity.add_activity(action, self, user)
  end

  private
    def set_published
      self.is_published = true unless self.is_published
      self.publish_at = Time.now
    end

    def create_new_tag_activity
      newTag = self.tag_list - ActsAsTaggableOn::Tag.pluck(:name)
      yield
      unless  self.is_draft
        tag_activity(newTag) if newTag.present?
      end
    end

    def tag_activity(newTag)
      act_type = ActivityType.get_type('post.newTag')
      new_act = create_activity key: 'post.newTag', owner: user,
        params: {"tag"=> newTag}
      new_act.update_column :activity_type_id, act_type.id
    end

    def post_activity
      action = self.is_published_changed? ? 'create' : 'update'
      Activity.add_activity(action, self)
    end

    def destroy_activity?
      deleted_at.blank? && !is_draft
    end

    def destroy_post_activity
      Activity.add_activity('destroy',self)
    end

    def set_is_draft
      self.is_draft = false
    end

    def send_email_notification
      users = User.where("id != ?", user_id)
      Resque.enqueue(PostNotification, users, self)
    end
end
