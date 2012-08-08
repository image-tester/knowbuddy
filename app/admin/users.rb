ActiveAdmin.register User do

  menu :priority => 4

  filter :name_or_email, :as => :string

  form do |f|
   f.inputs "Details" do
     f.input :name
     f.input :email
   end
     f.buttons
  end


  index do
    id_column
    column :name
    column :email
    column :sign_in_count

    column "Actions" do |user|
      raw "#{link_to 'View', admin_user_path(user), method: :get}
           #{link_to 'Edit', edit_admin_user_path(user), method: :get}
           #{link_to 'Deactivate', admin_user_path(user), method: :delete,
                  confirm: "Are you sure you want to deactivate this user?"}"
    end
  end

  controller do
   def destroy
     user = User.where("id = ?", params["id"]).first
     user.destroy
     flash[:notice] = "User was successfully deactivated"
     redirect_to admin_users_path
   end
  end


end

