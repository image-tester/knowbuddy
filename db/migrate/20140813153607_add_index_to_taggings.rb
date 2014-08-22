class AddIndexToTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, :tagger_id
    add_index :taggings, :tagger_type
  end
end
