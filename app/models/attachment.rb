class Attachment < ActiveRecord::Base
  # attr_accessible :post_id, :created_at, :updated_at, :post

  belongs_to :post

  IMAGE_FORMATS = ["image/jpeg", "image/png", "image/gif", "image/jpg"]

  ATTACHMENT_FORMATS = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg',
    'application/pdf', 'application/msword', 'text/plain', 'text/html',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document']

  IMAGE_STYLES = {
    medium: "300x300>",
    thumb: ["90x90#", :png] }

  has_attached_file :post, styles:
    lambda{ |a| IMAGE_FORMATS.include?(a.content_type) ? IMAGE_STYLES : {} },
    path: ":rails_root/public/uploaded_files/:attachment/:id/:style/:filename",
    url: "/uploaded_files/:attachment/:id/:style/:filename"

  validates_attachment_content_type :post, content_type: ATTACHMENT_FORMATS
end
