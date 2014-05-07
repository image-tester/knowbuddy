class AuditorObserver < ActiveRecord::Observer
observe :comment, :kyu_entry

  def after_create(record)
    users = User.where("id != ?", record.user_id)
    notify_class = (record.kind_of? KyuEntry) ? KyuNotification : CommentNotification
    Resque.enqueue(notify_class, users, record)
  end
end
