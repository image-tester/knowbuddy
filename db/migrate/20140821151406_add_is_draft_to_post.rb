class AddIsDraftToPost < ActiveRecord::Migration
  def change
    add_column :posts, :is_draft, :boolean, default: true
  end
end
