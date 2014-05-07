ActiveAdmin.register KyuEntry, as: "Deleted Posts" do
  scope :Deleted_Posts, default: true do |kyu|
    kyu = KyuEntry.only_deleted
  end

  menu priority: 2, label: "Deleted Posts"
  actions :all, except: [:edit, :new]

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

  index title: "Deleted Posts" do
    column :id
    column :subject
    column :user do |kyu|
      kyu.user.name || kyu.user.email
    end
    column :publish_at

    column "Actions" do |kyu|
      raw "#{link_to 'View', controller: "admin/deleted_posts",
        action: "deleted_post", id: kyu.id}
        #{link_to 'Delete', admin_post_path(kyu), method: :delete,
        confirm: "Are you sure you want to delete this Post permanently ?"}
        #{link_to 'Restore', controller: "admin/deleted_posts",
        action: "restore", id: kyu.id}"
    end
  end

  controller do
    def restore
      get_current_post.recover
      flash[:notice] = "Post was successfully restored"
      redirect_to controller: "admin/posts", action: "index"
    end

    def deleted_post
      @page_title = "Deleted Post"
      @kyu_entry = get_current_post
    end

    def get_current_post
      KyuEntry.only_deleted.find(params["id"])
    end
  end
end

