class Activity < PublicActivity::Activity
  attr_accessible :trackable_id, :trackable_type, :owner_id, :owner_type,
    :key, :parameters,:recipient_id, :recipient_type, :activity_type_id

  belongs_to :activity_type

  def self.latest_activities(at_page, per_page = 20)
    joins(:activity_type)
      .where("activity_types.is_active IS TRUE")
      .order("created_at desc").page(at_page).per(per_page)
  end
end
