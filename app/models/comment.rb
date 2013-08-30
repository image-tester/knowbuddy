class Comment < ActiveRecord::Base
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

  private

    def solr_reindex_kyu
      self.kyu_entry.solr_index!
    end
end
