class AuditorObserver < ActiveRecord::Observer
observe :comment, :kyu_entry

  def after_create(record)
    users = User.where("id != ?", record.user_id)
    (record.kind_of? KyuEntry) ? Resque.enqueue(KyuNotification, users, record)
      : Resque.enqueue(CommentNotification, users, record)
  end
end
