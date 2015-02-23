require 'rails_helper'

describe Attachment do
  describe 'Attach file' do
    it 'it should attach a file' do
      file = File.new('spec/fixtures/docs/sample.txt')
      a = Attachment.create(post: file)
      expect(a.post?).to eq true
      expect(a.post.url).to  match(/\/uploaded_files\/posts\/#{a.id}/)
    end
  end
end
