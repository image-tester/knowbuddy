class AddIndexToKyuEntries < ActiveRecord::Migration
  def change
    add_index :kyu_entries, :slug, unique: true
  end
end

