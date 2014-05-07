class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :comments, :kyu_entry_id, :post_id
    rename_column :attachments, :kyu_entry_id, :post_id
    add_index :comments, [:user_id, :post_id]
  end
end