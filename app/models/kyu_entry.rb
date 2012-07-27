class KyuEntry < ActiveRecord::Base
   extend FriendlyId
   friendly_id :subject, :use => :slugged
   acts_as_taggable_on :tags
   has_many :comments, :dependent => :destroy
   belongs_to :user
   validates_presence_of :content, :subject, :slug

   paginates_per 10

end
