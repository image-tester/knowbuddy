class AddKyuEntryIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :kyu_entry_id, :integer
  end
end
