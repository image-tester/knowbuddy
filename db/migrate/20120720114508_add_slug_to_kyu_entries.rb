class AddSlugToKyuEntries < ActiveRecord::Migration
  def change
    add_column :kyu_entries, :slug, :string
  end
end

