class AddIsInternalToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_internal, :boolean, default: false
  end
end
