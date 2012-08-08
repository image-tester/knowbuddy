ActiveAdmin.register Comment, :as => "Kyu Comments" do
  menu :priority => 3

  filter :comment
  filter :kyu_entry_id

  index do
    id_column
    column :comment do |f|
      truncate( f.comment, :length => 40)
    end
    column :kyu_entry_subject do |comment|
      KyuEntry.find(comment.kyu_entry_id).subject
    end
    column :user_name do |comment|
      User.with_deleted.find(comment.user_id).name
    end
    default_actions
  end
end

