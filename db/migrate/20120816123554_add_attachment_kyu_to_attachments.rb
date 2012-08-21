class AddAttachmentKyuToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.has_attached_file :kyu
    end
  end

  def self.down
    drop_attached_file :attachments, :kyu
  end
end
