require 'spec_helper'

describe Attachment do
  describe 'Attach file' do
    it 'it should attach a file' do
      file = File.new('spec/fixtures/docs/sample.txt')
      a = Attachment.create(kyu: file)
      a.kyu?.should == true
      a.kyu.url.should =~ /\/uploaded_files\/kyus\/#{a.id}/
    end
  end
end
