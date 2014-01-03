namespace :email do
  desc "send Mail to users who did not posted an article yet"
  task no_post_notifications: :environment do
    puts "Start rake task..."
    users_with_no_post = User.where("id not in (?)", KyuEntry.pluck(:user_id).uniq)
    users_with_no_post.each do |user|
      # Resque.enqueue(NoPostNotification, user)
      UserMailer.no_post_notification(user).deliver
    end
    puts "End rake task..."
  end
end