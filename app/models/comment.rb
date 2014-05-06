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
    {"1"=> kyu_entry.subject, "2" => kyu_entry.id}
  end

  private

    def solr_reindex_kyu
      self.kyu_entry.solr_index! unless self.user.blank?
    end

    def create_comment_activity
      comment_activity('create')
    end

    def update_comment_activity
      comment_activity('update')
    end

    def destroy_comment_activity
      comment_activity('destroy')
    end

    def comment_activity(action)
      new_act = create_activity action.to_sym, owner: user, params: activity_params
      act_type = ActivityType.get_type(new_act.key)
      new_act.update_column :activity_type_id, act_type.id
    end
end
