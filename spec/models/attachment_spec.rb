require 'spec_helper'

describe Attachment do
  describe 'Attach file' do
    it 'it should attach a file' do
      file = File.new('spec/fixtures/docs/sample.txt')
      a = Attachment.create(post: file)
      a.post?.should == true
      a.post.url.should =~ /\/uploaded_files\/posts\/#{a.id}/
    end
  end
end
