ActiveAdmin.register KyuEntry do

  menu priority: 1

  filter :subject
  filter :user , as: :select,
                 collection: User.with_deleted.user_collection_email_name

    form do |f|
      f.inputs "Details" do
        f.input :user,
                collection: User.with_deleted.user_collection_email_name
        f.input :content
        f.input :publish_at
        f.input :slug
      end
      f.buttons
    end

  index do
    id_column
    column :subject
    column :user do |user|
      User.with_deleted.find(user.user_id).name || User.with_deleted.
                                                   find(user.user_id).email
    end
    column :publish_at
    column "Actions" do |kyu|
      raw "#{link_to 'View', admin_kyu_entry_path(kyu), method: :get}
           #{link_to 'Edit', edit_admin_kyu_entry_path(kyu), method: :get}
           #{link_to 'Delete', admin_kyu_entry_path(kyu), method: :delete,
      confirm: "Are you sure you want to delete this KYU Entry permanently ?"}"
    end
  end

  controller do
   def destroy
     kyu = KyuEntry.with_deleted.where("slug = ?", params["id"]).first
     if kyu.deleted_at
       kyu.destroy!
     else
       kyu.destroy
       kyu.destroy
     end
     flash[:notice] = "KyuEntry was successfully destroyed"
     redirect_to admin_kyu_entries_path
   end
  end

end

