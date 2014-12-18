class Comment < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :post
  belongs_to :user
  validates_presence_of :comment

  delegate :subject, to: :post, prefix: true
  delegate :display_name, to: :user

  default_scope { order('updated_at DESC') }

  after_save :solr_reindex_post
  after_destroy :solr_reindex_post

  after_create :create_comment_activity
  after_update :update_comment_activity
  before_destroy :destroy_comment_activity

  def user
    User.with_deleted.find(user_id) if user_id
  end

  def activity_params
    {"post_subject"=> post.subject, "post_id" => post.id}
  end

  private

    def solr_reindex_post
      self.post.solr_index! unless self.user.blank?
    end

    def create_comment_activity
      Activity.add_activity('create',self)
    end

    def update_comment_activity
      Activity.add_activity('update',self)
    end

    def destroy_comment_activity
      Activity.add_activity('destroy',self)
    end
end
