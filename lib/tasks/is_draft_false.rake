namespace :draft do
  desc "Make all Existing Post is_draft to false"
  task make_is_draft_false: :environment do
    Post.find_each do |post|
      post.update_column(:is_draft, false)
    end
  end
end
