namespace :email do
  desc "send Mail to users who did not posted an article yet"
  task no_post_notifications: :environment do
    puts "Start task no_post_notifications"
    users_with_no_post = User.where("id not in (?)", KyuEntry.pluck(:user_id).uniq)
    users_with_no_post.each do |user|
      puts "Enqueued #{user.email}"
      Resque.enqueue(NoPostNotification, user)
    end
    puts "End task no_post_notifications"
  end

  desc "send Mail to users who have less post"
  task less_post_notifications: :environment do
    puts "Start task less_post_notifications"
    user_with_less_posts = User.joins(:kyu_entries).select('users.name, users.email, users.id,
      COUNT(users.id) as total').where('kyu_entries.deleted_at IS NULL').group('kyu_entries.user_id').
      having("count(users.id) <= #{TEN_ARTICLES}")
    user_with_less_posts.each do |user|
      puts "Enqueued #{user.email}"
      Resque.enqueue(LessPostNotification, user)
    end
    puts "End task less_post_notifications"
  end
end