class RenameColumnsInAttachments < ActiveRecord::Migration
  def change
    rename_column :attachments, :kyu_file_name, :post_file_name
    rename_column :attachments, :kyu_file_size, :post_file_size
    rename_column :attachments, :kyu_content_type, :post_content_type
    rename_column :attachments, :kyu_updated_at, :post_updated_at
  end
end
