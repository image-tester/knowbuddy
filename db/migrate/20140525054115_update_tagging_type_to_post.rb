class UpdateTaggingTypeToPost < ActiveRecord::Migration
  def up
    update "UPDATE taggings
      SET taggings.taggable_type = 'Post'
      WHERE taggings.taggable_type = 'KyuEntry'"
  end

  def down
    update "UPDATE taggings
      SET taggings.taggable_type = 'KyuEntry'
      WHERE taggings.taggable_type = 'Post'"
  end
end
