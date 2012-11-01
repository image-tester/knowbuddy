ActiveAdmin.register KyuEntry, as: "Posts"  do

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
      f.buttons do
        f.commit_button "Submit"
        f.commit_button "Cancel"
      end
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
      raw "#{link_to 'View', admin_post_path(kyu), method: :get}
           #{link_to 'Edit', edit_admin_post_path(kyu), method: :get}
           #{link_to 'Delete', admin_post_path(kyu), method: :delete,
      confirm: "Are you sure you want to delete this Post permanently ?"}"
    end
  end

  controller do
   def destroy
     kyu = KyuEntry.with_deleted.where("slug = ?", params[:id]).first
     if kyu.deleted_at
       kyu.destroy!
     else
       kyu.destroy
       kyu.destroy
     end
     flash[:notice] = "Post was successfully destroyed"
     redirect_to admin_posts_path
   end
  end

end

