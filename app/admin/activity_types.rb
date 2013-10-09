ActiveAdmin.register ActivityType do

  menu priority: 6

  filter :activity_type, as: :string

  #actions :all

  form do |f|
   f.inputs "Details" do
     f.input :activity_type, as: :string
     f.input :is_active, as: :radio
   end
     f.buttons
  end

  index do
    column :activity_type
    column :is_active
    #default_actions

    column "Actions" do |activity_type|
      unless activity_type.is_active?
          link_to 'Activate', controller: "admin/activity_types",
                        action: "activate", id: activity_type.id
     else
          link_to 'Deactivate', controller: "admin/activity_types",
                          action: "deactivate", id: activity_type.id
      end
    end
  end

  show do |activity|
      attributes_table do
        row :activity_type
        row :is_active
      end
    end

  controller do
    def activate
      activity_type = ActivityType.find(params["id"])
      activity_type.is_active = 1
      activity_type.save
      flash[:notice] = "Activity was successfully activated"
      redirect_to admin_activity_types_path
    end
    def deactivate
      activity_type = ActivityType.find(params["id"])
      activity_type.is_active = 0
      activity_type.save
      flash[:notice] = "Activity was successfully deactivated"
      redirect_to admin_activity_types_path
    end
  end
end