require "rails_helper"

describe AttachmentsController do

  let! (:user)  { create :user }
  let! (:post1) { create :post, user: user }
  let! (:file)  { fixture_file_upload('spec/fixtures/docs/sample.txt', 'text/plain') }
  let! (:invalid_file) { fixture_file_upload('spec/fixtures/docs/sample.txt', 'text') }

  before do
    sign_in user
    2.times { Attachment.create(post: file, post_id: post1.id) }
  end

  describe "Delete attachments" do
    it "should delete attachments" do
      expect{
        put :destroy, id: Attachment.first.id
      }.to change(Attachment, :count).by(-1)
      expect(response.body).to eq "true"
    end
  end

  describe "POST Create Attachment" do
    let! (:post2) { create :post, user: user }

    it "should create attachment" do
      expect {
        post :create, format: :json,
        post: { subject: "New Test", content: "test content" },
        post_id: post2.id, attachments_field: "", files: [file]
      }.to change(Attachment, :count).by(1)
    end

    it "should not create attachment" do
      expect {
        post :create, format: :json,
        post: { subject: "New Test", content: "test content" },
        post_id: post2.id, attachments_field: "", files: [invalid_file]
      }.to_not change(Attachment, :count)
      expect(response.status).to eq(422)
    end
  end
end
