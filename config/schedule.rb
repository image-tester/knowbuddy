set :cron_log, "log/cronjob.log"
env :PATH, ENV['PATH']

every 1.day, at:  "4:30 am" do
  puts "====@@ Notification alert  ===="
  rake "email:check_rule"
end
