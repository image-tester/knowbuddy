require 'rails_helper'

describe Post do
  include SolrSpecHelper

  before(:all) do
    solr_setup
  end

  after(:all) do
    Post.remove_all_from_index!
  end

  describe 'search_post(search_key)' do
    it 'should get the posts which matches keyword' do
      keyword = "xyZ"
      post1 = create :post, subject: "Abc", content: "abc"
      post2 = create :post, subject: "XYz", content: "abc"
      post2.update_column(:publish_at, 1.day.ago)
      post3 = create :post, subject: "Abc", content: "xyZ"
      Post.solr_reindex
      expect(Post.search_post(keyword)).to eq [post3,post2]
    end

    it 'should not any result if keyword doesnot match' do
      keyword = "123"
      post1 = create :post, subject: "Abc", content: "abc"
      post2 = create :post, subject: "XYz", content: "abc"
      post3 = create :post, subject: "Abc", content: "xyZ"
      Post.solr_reindex
      expect(Post.search_post(keyword)).to eq []
    end
  end
end
