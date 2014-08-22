class Activity < PublicActivity::Activity
  attr_accessible :trackable_id, :trackable_type, :owner_id, :owner_type,
    :key, :parameters,:recipient_id, :recipient_type, :activity_type_id

  belongs_to :activity_type

  def self.latest_activities(at_page = 1, per_page = 20)
    joins(:activity_type)
      .where("activity_types.is_active IS TRUE")
      .order("created_at desc").page(at_page).per(per_page)
  end

  def self.add_activity(action, record)
    unless record.is_draft
      new_act = record.create_activity action.to_sym,
        owner: (record.kind_of? User) ? record : record.user,
        params: record.activity_params
      act_type = ActivityType.get_type(new_act.key)
      new_act.update_column :activity_type_id, act_type.id
    end
  end
end
