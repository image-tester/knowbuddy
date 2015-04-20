ActiveAdmin.register Post, as: "Posts"  do
  permit_params :id, :publish_at, :subject,
  :tag_list, :user_id, :slug, :is_draft, :is_internal, :content

  scope :published, default: true
  scope :draft

  menu priority: 1
  config.sort_order = "updated_at_desc"
  filter :subject
  filter :user , as: :select,
    collection: User.with_deleted.user_collection_email_name

  form do |f|
    f.inputs "Details" do
      f.input :user,
        collection: User.with_deleted.user_collection_email_name
      f.input :subject
      f.input :content
      f.input :is_internal
    end
    f.actions
  end

  index do
    id_column
    column :subject
    column :user do |post|
      post.user_name
    end

    column "Date", :updated_at
    column "Internal", :is_internal
    column "Actions" do |post|
      raw "#{link_to "View", admin_post_path(post), method: :get}
        #{(link_to "Edit", edit_admin_post_path(post),
          method: :get) unless post.is_draft}
        #{ link_to "Delete", admin_post_path(post),
          method: :delete,
          data: { confirm: "Are you sure you want to delete
          this Post permanently ?" } }"
    end
  end

  show do |post|
    attributes_table do
      row :subject
      row :content do |post|
        raw RedCloth.new(post.content).to_html
      end
      row :user do |post|
        post.user.active? ? post.user : post.user_name
      end
      row :slug
      row :is_draft do
        post.is_draft? ? "YES" : "NO"
      end
      row :is_internal do
        post.is_internal? ? "YES" : "NO"
      end
      row :created_at
      row :updated_at
    end
  end

  controller do
    def destroy
      post = Post.get_post(params[:id])
      post.destroy unless post.deleted_at?
      post.destroy
      flash[:notice] = "Post was successfully destroyed"
      redirect_to admin_posts_path
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
