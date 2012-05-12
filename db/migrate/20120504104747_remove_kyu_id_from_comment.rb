class RemoveKyuIdFromComment < ActiveRecord::Migration
  def up
    remove_column :comments, :kyu_id
  end

  def down
    add_column :comments, :kyu_id, :integer
  end
end
