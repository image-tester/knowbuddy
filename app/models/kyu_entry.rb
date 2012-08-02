class KyuEntry < ActiveRecord::Base
   extend FriendlyId
   friendly_id :subject, use: :slugged
   acts_as_taggable_on :tags
   has_many :comments, dependent: :destroy
   belongs_to :user
   validates_presence_of :content, :subject, :slug

   attr_accessible :subject, :content

   paginates_per 10

   searchable do
     text :content, :subject
     text :comments do
      comments.map(&:comment)
     end
   end
end

