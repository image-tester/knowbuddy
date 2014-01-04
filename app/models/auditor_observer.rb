class AuditorObserver < ActiveRecord::Observer
observe :comment, :kyu_entry

  def after_create(record)
    (record.kind_of? KyuEntry) ? Resque.enqueue(KyuNotification, User.all, record)
      : Resque.enqueue(CommentNotification, User.all, record)
  end
end
