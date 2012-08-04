ActiveAdmin.register User, :as => "Inactive Users" do

  menu :priority => 3
  actions :index

  scope :Inactive, :default => true do |user|
    user = User.only_deleted
  end

  filter :name

  index do
    id_column
    column :name
    column :email
    column :sign_in_count

    column "Actions" do |user|
      link_to 'Activate', :controller => "admin/inactive_users",
                          :action => "activate", :id => user.id
    end
  end

  controller do
    def activate
      User.only_deleted.where("id = ?", params["id"]).first.recover
      redirect_to :controller => "admin/users", :action => "index"
    end
  end
end

