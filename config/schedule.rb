set :cron_log, "log/cronjob.log"
env :PATH, ENV['PATH']

every :sunday, :at => '11pm' do
  rake "email:no_post_notifications"
  rake "email:less_post_notifications"
end
