class Activity < PublicActivity::Activity
  belongs_to :activity_type

  def self.latest_activities(at_page = 1, per_page =  ACTIVITIES_PER_PAGE)
    joins(:activity_type)
      .where("activity_types.is_active IS TRUE")
      .order("created_at desc").page(at_page).per(per_page)
  end

  def self.add_activity(action, record, user=nil)
    new_act = record.create_activity action.to_sym,
      owner: user || ((record.kind_of? User) ? record : record.user),
      params: record.activity_params
    act_type = ActivityType.get_type(new_act.key)
    new_act.update_column :activity_type_id, act_type.id
  end
end
