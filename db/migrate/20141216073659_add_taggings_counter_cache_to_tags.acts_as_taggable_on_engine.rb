# This migration comes from acts_as_taggable_on_engine (originally 3)
class AddTaggingsCounterCacheToTags < ActiveRecord::Migration
  def self.up
    unless ActsAsTaggableOn::Tag.column_names.include?('taggings_count')
      add_column :tags, :taggings_count, :integer, default: 0
    end
    # ActsAsTaggableOn::Tag.reset_column_information
    # ActsAsTaggableOn::Tag.find_each do |tag|
    #   ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
    # end
  end

  def self.down
    remove_column :tags, :taggings_count
  end
end
