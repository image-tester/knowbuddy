class KyuEntry < ActiveRecord::Base
   acts_as_taggable_on :tags 
   belongs_to :user
    validates_presence_of :content, :subject
    
    paginates_per 10
end
