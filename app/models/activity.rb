class Activity < PublicActivity::Activity
  attr_accessible :trackable_id, :trackable_type, :owner_id, :owner_type, :key,
                   :parameters,:recipient_id, :recipient_type, :activity_type_id

  belongs_to :activity_type

end