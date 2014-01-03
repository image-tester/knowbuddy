namespace :email do
  desc "Populate activity type data"
  task notifications: :environment do
    puts "Start rake task..."
    users_with_no_post = User.where("id not in (?)", mail_user)
    users_with_no_post.each do |user|
      Resque.enqueue(NoPostNotification, user)
    end
    puts "End rake task..."
  end
end