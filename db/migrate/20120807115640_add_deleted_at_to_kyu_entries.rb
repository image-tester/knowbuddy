class AddDeletedAtToKyuEntries < ActiveRecord::Migration
  def change
    add_column :kyu_entries, :deleted_at, :datetime
  end
end
