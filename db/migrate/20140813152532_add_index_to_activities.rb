class AddIndexToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :activity_type_id
  end
end
