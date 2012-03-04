class AddUserIdToKyuEntries < ActiveRecord::Migration
  def change
    add_column :kyu_entries, :user_id, :integer
  end
end
