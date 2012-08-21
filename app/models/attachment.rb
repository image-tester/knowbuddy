class Attachment < ActiveRecord::Base

belongs_to :kyu_entry

validates_attachment_content_type :kyu, content_type: ['image/jpeg',
  'image/png', 'image/gif', 'image/jpg', 'application/pdf',
  'application/msword', 'text/plain', 'text/html',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document']

has_attached_file :kyu,
  styles: lambda{ |a| ["image/jpeg", "image/png", "image/gif",
    "image/jpg"].include?(a.content_type) ? { medium: "300x300>",
    thumb: ["90x90#", :png] } : {} },
  path: ":rails_root/public/uploaded_files/:attachment/:id/:style/:filename",
  url: "/uploaded_files/:attachment/:id/:style/:filename"
end
