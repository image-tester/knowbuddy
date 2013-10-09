class Comment < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessible :comment, :created_at, :kyu_entry_id, :updated_at, :user_id

  belongs_to :kyu_entry
  belongs_to :user

  validates_presence_of :comment

  delegate :subject, to: :kyu_entry, prefix: true

  default_scope order: 'created_at DESC'
  scope :list, lambda { |user_id|
    where('user_id = ?', user_id)
  }

  after_save :solr_reindex_kyu
  after_destroy :solr_reindex_kyu

  after_create :create_comment_activity
  after_update :update_comment_activity
  before_destroy :destroy_comment_activity


  private

    def solr_reindex_kyu
      self.kyu_entry.solr_index!
    end

    def create_comment_activity
      (self.create_activity :create, params: {"1"=> self.kyu_entry.subject,
       "2" => self.kyu_entry.id}).tap{|a| a.owner_id = self.user_id;
         a.owner_type = 'User'; a.activity_type_id = 4; a.save}
    end

    def update_comment_activity
      (self.create_activity :update, params: {"1"=> self.kyu_entry.subject,
       "2" => self.kyu_entry.subject}).tap{|a| a.owner_id = self.user_id;
        a.owner_type = 'User'; a.activity_type_id = 5; a.save}
    end

    def destroy_comment_activity
      (self.create_activity :destroy, params: {"1"=> self.kyu_entry.subject,
       "2" => self.kyu_entry.id}, recipient: @kyu_entry)
      .tap{|a| a.owner_id = self.user_id; a.owner_type = 'User';
       a.activity_type_id = 6; a.save}
    end
end
