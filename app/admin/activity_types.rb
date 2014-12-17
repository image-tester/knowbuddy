ActiveAdmin.register ActivityType do

  menu priority: 6

  filter :activity_type, as: :string

  form do |f|
    f.inputs "Details" do
      f.input :activity_type, as: :string
      f.input :is_active, as: :radio
    end
    f.actions
  end

  index do
    column :activity_type
    column :is_active

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
      ActivityType.find(params["id"]).try(:activate)
      flash[:notice] = "Activity was successfully activated."
      redirect_to admin_activity_types_path
    end

    def deactivate
      ActivityType.find(params["id"]).try(:deactivate)
      flash[:notice] = "Activity was successfully deactivated."
      redirect_to admin_activity_types_path
    end
  end
end
