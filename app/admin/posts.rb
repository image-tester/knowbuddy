ActiveAdmin.register Post, as: "Posts"  do

  scope :published, default: true do |posts|
    posts = Post.published
  end

  scope(:drafted) { |posts| posts = Post.draft }

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
    end
    f.buttons do
      f.commit_button "Submit"
      f.commit_button "Cancel"
    end
  end

  index do
    id_column
    column :subject
    column :user do |post|
      post.user_name
    end

    column 'Date', :updated_at
    column "Actions" do |post|
      raw "#{link_to 'View', admin_post_path(post), method: :get}
        #{(link_to 'Edit', edit_admin_post_path(post), method: :get) unless post.is_draft}
        #{link_to 'Delete', admin_post_path(post), method: :delete,
        confirm: 'Are you sure you want to delete this Post permanently ?'}"
    end
  end

  show do |post|
    attributes_table do
      row :subject
      row :content
      row :user do |post|
        post.user.active? ? post.user : post.user_name
      end
      row :slug
      row :is_draft
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
  end
end
