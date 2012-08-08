ActiveAdmin.register User, :as => "Inactive Users" do

  menu :priority => 5
  actions :index

  scope :Inactive, :default => true do |user|
    user = User.only_deleted
  end

  filter :name_or_email, :as => :string

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
      if User.only_deleted.find(params["id"]).name
        User.only_deleted.where("id = ?", params["id"]).first.recover
      else
        user = User.only_deleted.where("id = ?", params["id"]).first
        user.deleted_at = nil
        user.save(:validate => false)
      end
      flash[:notice] = "User was successfully activated"
      redirect_to controller: "admin/users", action: "index"
    end
  end
end

