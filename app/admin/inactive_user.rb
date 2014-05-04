ActiveAdmin.register User, as: "Inactive Users" do

  menu priority: 5
  actions :index

  scope :Inactive, default: true do |user|
    user = User.only_deleted
  end

  filter :name_or_email, as: :string

  index do
    id_column
    column :name
    column :email
    column :sign_in_count

    column "Actions" do |user|
      link_to 'Activate', controller: "admin/inactive_users",
        action: "activate", id: user.id
    end
  end

  controller do
    def activate
      user = User.get_user(params["id"])
      user.activate
      flash[:notice] = "User was successfully activated."
      redirect_to controller: "admin/users", action: "index"
    end
  end
end
