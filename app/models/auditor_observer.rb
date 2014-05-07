class AuditorObserver < ActiveRecord::Observer
observe :comment, :post

  def after_create(record)
    users = User.where("id != ?", record.user_id)
    notify_class = (record.kind_of? Post) ? PostNotification : CommentNotification
    Resque.enqueue(notify_class, users, record)
  end
end
