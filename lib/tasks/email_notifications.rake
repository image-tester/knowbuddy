namespace :email do
  desc "send Mail to users who did not posted an article yet"
  task no_post_notifications: :environment do
    puts "Start rake task..."
    users_with_no_post = User.where("id not in (?)", KyuEntry.pluck(:user_id).uniq)
    users_with_no_post.each do |user|
      Resque.enqueue(NoPostNotification, user)
    end
    puts "End rake task..."
  end

  desc "send Mail to users who have less post"
  task less_post_notifications: :environment do
    puts "Start rake task..."
    user_with_less_posts = User.joins(:kyu_entries).select('users.name, users.email, users.id,
      COUNT(users.id) as total').where('kyu_entries.deleted_at IS NULL').group('kyu_entries.user_id').
      having("count(users.id) < 5")
    user_with_less_posts.each do |user|
      Resque.enqueue(LessPostNotification, user)
    end
    puts "End rake task..."
  end
end