namespace :post do
  desc "Make all Existing Post is_draft to false"
  task make_is_draft_false: :environment do
    Post.find_each do |post|
      post.update_column(:is_draft, false)
    end
  end

  desc "Mark is_published true for published posts."
  task make_is_draft_false: :environment do
    published_posts = Post.where('publish_at IS NOT NULL')
    published_posts.find_each do |post|
      post.update_column(:is_published, true)
    end
  end
end
