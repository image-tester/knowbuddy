class KyuEntry < ActiveRecord::Base
    belongs_to :user
    validates_presence_of :content, :subject
    
    paginates_per 10
end
