class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :activity_type
      t.boolean :is_active

      t.timestamps
    end
  end
end
