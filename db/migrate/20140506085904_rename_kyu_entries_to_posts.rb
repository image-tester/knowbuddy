class RenameKyuEntriesToPosts < ActiveRecord::Migration
  def change
    rename_table :kyu_entries, :posts
  end
end
