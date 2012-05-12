class AuditorObserver < ActiveRecord::Observer
observe :comment, :kyu_entry

   def after_create(record) 
      if record.kind_of? KyuEntry
        UserMailer.send_notification_on_new_KYU(User.all, record).deliver
      else
        UserMailer.send_notification_on_new_Comment(User.all, record).deliver
      end
   end 
end
