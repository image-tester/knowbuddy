ActiveAdmin.register User do
  filter :name
  filter :email

  index do
    id_column
    column :name
    column :email
    column :sign_in_count
    default_actions
  end

end

