class CreateRuleEngines < ActiveRecord::Migration
  def change
    create_table :rule_engines do |t|
      t.string :rule, null: false
      t.string :rule_for
      t.string :frequency
      t.string :schedule
      t.text :subject
      t.text :body
      t.boolean :active, default: true
      t.integer :min_count
      t.integer :max_count
      t.string :max_duration

      t.timestamps
    end
  end
end
