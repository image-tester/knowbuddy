ActiveAdmin.register KyuEntry do
  filter :subject
  filter :user_id

  index do
    id_column
    column :subject
    column :user_id
    column :publish_at
    default_actions
  end

end

