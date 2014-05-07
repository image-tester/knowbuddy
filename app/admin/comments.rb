ActiveAdmin.register Comment, as: "PostsComments" do
  menu priority: 3

  filter :comment
  filter :post_id, label: "Post"

  index do
    id_column

    column :comment do |f|
      truncate(f.comment, length: 40)
    end

    column :post_subject do |comment|
      comment.post.subject
    end

    column :user_name do |comment|
      comment.user.display_name
    end

    default_actions
  end

  show do |comment|
    attributes_table do
      row "Post" do |s|
        s.post.subject
      end
      row :user do |c|
        c.user.active? ? c.user : c.user.display_name
      end
      row :comment
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :post , label: "Post"
      f.input :user
      f.input :comment
      f.input :created_at
      f.input :updated_at
    end
    f.buttons
  end
end
