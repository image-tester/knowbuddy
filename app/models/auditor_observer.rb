class AuditorObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    users = User.where("id != ?", record.user_id)
    Resque.enqueue(CommentNotification, users, record)
  end
end
