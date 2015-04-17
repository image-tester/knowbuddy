class Activity < PublicActivity::Activity
  belongs_to :activity_type
  scope :order_desc, -> { order("created_at desc") }
  scope :latest, ->(from_time) { where("activities.created_at >= ?",
    from_time) }

  def self.latest_activities(at_page = 1, per_page =
    ACTIVITIES_PER_PAGE)
    with_active_activity_types.
      order_desc.page(at_page).per(per_page)
  end

  def self.add_activity(action, record, user=nil)
    new_act = record.create_activity action.to_sym,
      owner: user || ((record.kind_of? User) ? record : record.user),
      params: record.activity_params
    act_type = ActivityType.get_type(new_act.key)
    new_act.update_column :activity_type_id, act_type.id
  end

  def get_owner
    owner || User.find_owner(owner_id)
  end

  def self.with_active_activity_types
    joins(:activity_type).
      where("activity_types.is_active IS TRUE")
  end

  def self.from_past_24_hrs
    with_active_activity_types.latest(1.day.ago).order_desc
  end
end
