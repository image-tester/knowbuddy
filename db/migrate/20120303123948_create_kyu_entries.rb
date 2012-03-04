class CreateKyuEntries < ActiveRecord::Migration
  def change
    create_table :kyu_entries do |t|
      t.string :subject
      t.text :content
      t.datetime :publish_at

      t.timestamps
    end
  end
end
