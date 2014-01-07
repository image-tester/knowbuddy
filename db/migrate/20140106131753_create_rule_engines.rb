class CreateRuleEngines < ActiveRecord::Migration
  def change
    create_table :rule_engines do |t|
      t.string :name
      t.string :rule_for
      t.integer :min_post
      t.string :frequency
      t.string :schedule
      t.string :mail_for
      t.boolean :active

      t.timestamps
    end
  end
end
