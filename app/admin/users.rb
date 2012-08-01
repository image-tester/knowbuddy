ActiveAdmin.register User do
  filter :name
  filter :email
  #actions :all, except: [:destroy]

  index do
    id_column
    column :name
    column :email
    column :sign_in_count

    column "Actions" do |user|
      raw "#{link_to 'View', admin_user_path(user), method: :get}
           #{link_to 'Edit', edit_admin_user_path(user), method: :get}
           #{link_to 'Deactivate', admin_user_path(user), method: :delete}"
    end
  end
end

