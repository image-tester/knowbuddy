namespace :draft do
  desc "Make all Existing Post is_draft to false"
  task make_is_draft_false: :environment do
    posts = Post.all
    posts.each do |post|
      post.is_draft = false
      post.save
    end
  end
end
