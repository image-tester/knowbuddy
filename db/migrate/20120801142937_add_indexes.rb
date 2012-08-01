class AddIndexes < ActiveRecord::Migration
  def change
    add_index :comments, [:user_id, :kyu_entry_id]
    add_index :kyu_entries, :user_id
  end
end
