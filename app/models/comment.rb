class Comment < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessible :comment, :created_at, :kyu_entry_id, :updated_at, :user_id
  belongs_to :kyu_entry
  belongs_to :user

  validates_presence_of :comment

  delegate :subject, to: :kyu_entry, prefix: true

  default_scope order: 'created_at DESC'

  after_save :solr_reindex_kyu
  after_destroy :solr_reindex_kyu

  after_create :create_comment_activity
  after_update :update_comment_activity
  before_destroy :destroy_comment_activity

  def user
    User.with_deleted.find(user_id)
  end

  def activity_params
    {"post_subject"=> kyu_entry.subject, "post_id" => kyu_entry.id}
  end

  private

    def solr_reindex_kyu
      self.kyu_entry.solr_index! unless self.user.blank?
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
