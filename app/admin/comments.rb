ActiveAdmin.register Comment, as: "PostsComments" do
  menu priority: 3

  filter :comment
  filter :kyu_entry_id, label: "Post"

  index do
    id_column
    column :comment do |f|
      truncate( f.comment, length: 40)
    end
    column :post_subject do |comment|
      KyuEntry.find(comment.kyu_entry_id).subject
    end
    column :user_name do |comment|
      User.with_deleted.find(comment.user_id).name
    end
    default_actions
  end

  show do |comment|
      attributes_table do
        row "Post" do |s|
          KyuEntry.find(s.kyu_entry_id).subject
        end
        row :user
        row :comment
          row :created_at
          row :updated_at
        row "subject" do |s|
          KyuEntry.find(s.kyu_entry_id).subject
        end

       end
    end

  form do |f|
    f.inputs "Details" do
        f.input :kyu_entry , label: "Post"
        f.input :user
        f.input :comment
        f.input :created_at
        f.input :updated_at
      end
      f.buttons
    end
end

